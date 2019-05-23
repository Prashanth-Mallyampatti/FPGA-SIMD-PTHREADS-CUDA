#include <stdio.h>
#include <stdlib.h>
#include "mysort.h"
#include <fcntl.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctime>
#include <string>
#ifdef APPLE
#include <OpenCL/opencl.h>
//#include "scoped_array.h"
#else
#include "CL/opencl.h"
#include "AOCL_Utils.h"
using namespace aocl_utils;
#endif
#ifdef APPLE
// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 1;
cl_device_id device; // num_devices elements
cl_context context = NULL;
cl_command_queue queue; // num_devices elements
cl_program program = NULL;
cl_kernel kernel; // num_devices elements
#else
// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 0;
scoped_array<cl_device_id> device; // num_devices elements
cl_context context = NULL;
scoped_array<cl_command_queue> queue; // num_devices elements
cl_program program = NULL;
scoped_array<cl_kernel> kernel; // num_devices elements
#endif

#ifdef APPLE
static int LoadTextFromFile(const char *file_name, char **result_string, size_t *string_len);
#define LOCAL_MEM_SIZE = 1024;
void _checkError(int line,
								 const char *file,
								 cl_int error,
                 const char *msg,
                 ...);



#define checkError(status, ...) _checkError(__LINE__, __FILE__, status, __VA_ARGS__)
#endif

bool init_opencl();
void merge_s(float **array, int left, int middle, int right) {
    float *temp = (float*) malloc(sizeof(float)*(right-left+1));
    int iter1 = left;
    int iter2 = middle + 1;
    int temp_iter = 0;
    int var;
    bool iter1Increment = false;
    bool iter2Increment = false;

    if ((*array)[iter1] < (*array)[iter1 + 1])
        iter1Increment = true;
    if ((*array)[iter2] < (*array)[iter2 + 1])
        iter2Increment = true;
    
    if(iter1Increment && iter2Increment)
    {
	
        while ((iter1 <= middle) && (iter2 <= right)) {
            if ((*array)[iter1] <= (*array)[iter2]) {
                temp[temp_iter++] = (*array)[iter1];
                iter1 = iter1 + 1;
            }
            else {
                temp[temp_iter++] = (*array)[iter2];
                iter2 = iter2 + 1;
            }
        }
        while (iter1 <= middle) {
            temp[temp_iter++] = (*array)[iter1];
            iter1 = iter1 + 1;
        }
        while (iter2 <= right) {
            temp[temp_iter++] = (*array)[iter2];
            iter2 = iter2 + 1;
        }
        for (int i = left; i <= right; i++) {
            (*array)[i] = temp[i - left];
        }
	}

    else if(iter1Increment == 1 && !iter2Increment)
    {
        iter2 = right;
        while(iter1 <=middle && iter2 >= middle+1)
        {
            if((*array)[iter1] <= (*array)[iter2])
            {
                temp[temp_iter++] = (*array)[iter1];
                iter1 = iter1 + 1;
            }
            else
            {
                temp[temp_iter++] = (*array)[iter2];
                iter2 = iter2 - 1;
            }
        }
        while(iter1 <= middle)
        {
            temp[temp_iter++] = (*array)[iter1];
            iter1 = iter1 + 1;
        }
        while(iter2 >=middle)
        {
            temp[temp_iter++] = (*array)[iter2];
            iter2--;
        }
        for (int i = left; i <= right; i++) {
            (*array)[i] = temp[i - left];
        }
    }
    
    else if(!iter1Increment && iter2Increment)
    {
        iter1 = middle;
        while(iter1 >=left && iter2 <= right)
        {
            if((*array)[iter1] <= (*array)[iter2])
            {
                temp[temp_iter++] = (*array)[iter1];
                iter1 = iter1 - 1 ;
            }
            else
            {
                temp[temp_iter++] = (*array)[iter2];
                iter2 = iter2 + 1;
            }
        }
        while(iter1 >= left)
        {
            temp[temp_iter++] = (*array)[iter1];
            iter1 = iter1 - 1;
        }
        while(iter2 <=right)
        {
            temp[temp_iter++] = (*array)[iter2];
            iter2++;
        }
        for (int i = left; i <= right; i++) {
            (*array)[i] = temp[i - left];
        }
    }
    
    else
    {
        iter1 = middle;
        iter2 = right;
        while(iter1 >=left && iter2 >= middle)
        {
            if((*array)[iter1] <= (*array)[iter2])
            {
                temp[temp_iter++] = (*array)[iter1];
                iter1 = iter1 - 1 ;
            }
            else
            {
                temp[temp_iter++] = (*array)[iter2];
                iter2 = iter2 - 1;
            }
        }
        while(iter1 >= left)
        {
            temp[temp_iter++] = (*array)[iter1];
            iter1 = iter1 - 1;
        }
        while(iter2 >=middle)
        {
            temp[temp_iter++] = (*array)[iter2];
            iter2--;
        }
        for (int i = left; i <= right; i++) {
            (*array)[i] = temp[i - left];
        }
    }
    free(temp);
}

int fpga_sort(int num_of_elements, float *data)
{
    init_opencl();
    size_t size = num_of_elements * sizeof(float);
    size_t num_elems_size = sizeof(int);
    float* input = data;

    size_t local_size = 1;
    size_t global_size = 2;

    cl_int status;

    cl_mem d_input = clCreateBuffer(context, CL_MEM_READ_WRITE, size, NULL, 
				    &status);
    cl_mem d_elems = clCreateBuffer(context, CL_MEM_READ_ONLY, num_elems_size, NULL,
				    &status);

    
    cl_int err = clEnqueueWriteBuffer(queue[0], d_input, CL_TRUE, 0, size,input, 0,
				NULL, NULL);
    err = clEnqueueWriteBuffer(queue[0], d_elems, CL_TRUE, 0, num_elems_size, 
				&num_of_elements, 0, NULL, NULL);
    
    clFinish(queue[0]);

    err = clSetKernelArg(kernel[0], 0, sizeof(cl_mem), &d_input);
    err = clSetKernelArg(kernel[0], 1, sizeof(cl_mem), &d_elems);

    cl_event kernel_event;
    err = clEnqueueNDRangeKernel(queue[0], kernel[0], 1, NULL, &global_size,
				&local_size, 0, NULL, &kernel_event);
    

    clEnqueueReadBuffer(queue[0], d_input, CL_TRUE, 0, size, input, 0, NULL,
			NULL);

    int prev_left = 0;
    int prev_right = num_of_elements / global_size - 1;

/*float b[]={2.0,3.0,4.0,7.0,4.0,3.0,2.0,1.0};
float *c = b;
  */
    int left, right;
    for (int i = 1; i < global_size; i++)
    {
         left = i * num_of_elements / global_size;
         right = left + num_of_elements / global_size - 1;
	
        merge_s(&data, prev_left, prev_right, right);

        prev_right = right;
    }

    return 0;
}



// Initializes the OpenCL objects.
bool init_opencl() {
  int err;
  cl_int status;

  printf("Initializing OpenCL\n");
#ifdef APPLE
  int gpu = 1;
  err = clGetDeviceIDs(NULL, gpu ? CL_DEVICE_TYPE_GPU : CL_DEVICE_TYPE_CPU, 1, &device, NULL);
  if (err != CL_SUCCESS)
  {
    fprintf(stderr, "Error: Failed to create a device group!\n");
    return EXIT_FAILURE;
  }
  // Create the context.
  context = clCreateContext(NULL, 1, &device, NULL, NULL, &status);
  checkError(status, "Failed to create context");
#else 
  if(!setCwdToExeDir()) {
    return false;
  }

  // Get the OpenCL platform.
  platform = findPlatform("Altera");
 if(platform == NULL) {
   printf("ERROR: Unable to find Altera OpenCL platform.\n");
   return false;
 }

  // Query the available OpenCL device.
  device.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));
  printf("Platform: %s\n", getPlatformName(platform).c_str());
  printf("Using %d device(s)\n", num_devices);
  for(unsigned i = 0; i < num_devices; ++i) {
    printf("  %s\n", getDeviceName(device[i]).c_str());
  }
  // Create the context.
  context = clCreateContext(NULL, num_devices, device, NULL, NULL, &status);
  checkError(status, "Failed to create context");
#endif

  // Create the program for all device. Use the first device as the
  // representative device (assuming all device are of the same type).
#ifndef APPLE
  std::string binary_file = getBoardBinaryFile("fpgasort", device[0]);
  printf("Using AOCX: %s\n", binary_file.c_str());
  program = createProgramFromBinary(context, binary_file.c_str(), device, num_devices);

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
  checkError(status, "Failed to build program");

  //Create per-device objects.
  queue.reset(num_devices);
  kernel.reset(num_devices);
  for(unsigned i = 0; i < num_devices; ++i) {
    // Command queue.
    queue[i] = clCreateCommandQueue(context, device[i], CL_QUEUE_PROFILING_ENABLE, &status);
    checkError(status, "Failed to create command queue");

    // Kernel.
    const char *kernel_name = "fpgasort";
    kernel[i] = clCreateKernel(program, kernel_name, &status);
    checkError(status, "Failed to create kernel");

  }
#else
  char *source = 0;
  size_t length = 0;
  LoadTextFromFile("fpgasort.cl", &source, &length);
  const char *kernel_name = "fpgasort";
  program = clCreateProgramWithSource(context, 1, (const char **) & source, NULL, &err);

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
  checkError(status, "Failed to build program");

  queue = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
  kernel = clCreateKernel(program, kernel_name, &status);
#endif
  return true;
}

void cleanup() {
#ifndef APPLE
  for(unsigned i = 0; i < num_devices; ++i) {
    if(kernel && kernel[i]) {
      clReleaseKernel(kernel[i]);
    }
    if(queue && queue[i]) {
      clReleaseCommandQueue(queue[i]);
    }
  }
#else
  clReleaseKernel(kernel);
  clReleaseCommandQueue(queue);
#endif
  if(program) {
    clReleaseProgram(program);
  }
  if(context) {
    clReleaseContext(context);
  }
}
#ifdef APPLE
static int LoadTextFromFile(
    const char *file_name, char **result_string, size_t *string_len)
{
    int fd;
    unsigned file_len;
    struct stat file_status;
    int ret;
 
    *string_len = 0;
    fd = open(file_name, O_RDONLY);
    if (fd == -1)
    {
        printf("Error opening file %s\n", file_name);
        return -1;
    }
    ret = fstat(fd, &file_status);
    if (ret)
    {
        printf("Error reading status for file %s\n", file_name);
        return -1;
    }
    file_len = file_status.st_size;
 
    *result_string = (char*)calloc(file_len + 1, sizeof(char));
    ret = read(fd, *result_string, file_len);
    if (!ret)
    {
        printf("Error reading from file %s\n", file_name);
        return -1;
    }
 
    close(fd);
 
    *string_len = file_len;
    return 0;
}

// High-resolution timer.
double getCurrentTimestamp() {
#ifdef _WIN32 // Windows
  // Use the high-resolution performance counter.

  static LARGE_INTEGER ticks_per_second = {};
  if(ticks_per_second.QuadPart == 0) {
    // First call - get the frequency.
    QueryPerformanceFrequency(&ticks_per_second);
  }

  LARGE_INTEGER counter;
  QueryPerformanceCounter(&counter);

  double seconds = double(counter.QuadPart) / double(ticks_per_second.QuadPart);
  return seconds;
#else         // Linux
  timespec a;
  clock_gettime(CLOCK_MONOTONIC, &a);
  return (double(a.tv_nsec) * 1.0e-9) + double(a.tv_sec);
#endif
}

void _checkError(int line,
								 const char *file,
								 cl_int error,
                 const char *msg,
                 ...) {
	// If not successful
	if(error != CL_SUCCESS) {
		// Print line and file
    printf("ERROR: ");
    printf("\nLocation: %s:%d\n", file, line);

    // Print custom message.
    va_list vl;
    va_start(vl, msg);
    vprintf(msg, vl);
    printf("\n");
    va_end(vl);

    // Cleanup and bail.
    cleanup();
    exit(error);
    }
}
#endif
