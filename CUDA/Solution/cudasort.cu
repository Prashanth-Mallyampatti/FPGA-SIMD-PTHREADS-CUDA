/*

Name: Prashanth Mallyampatti
Student Id: 200250501
Unity Id: pmallya
Algorithm: Bitonic Sort

*/

#include <stdio.h>
#include<stdlib.h>
#include <time.h>
#include<assert.h>
#include<sys/time.h>

int threads_ = 0, blocks_ = 0;

#ifdef __cplusplus
extern "C"
{
#endif

__global__ 
void bitonic_sort(float *values, int j, int k)
{
	int i = threadIdx.x + blockDim.x * blockIdx.x;
	int ij = i^j;

	//ascending
	if (ij > i && (i & k) == 0 && values[i] > values[ij])
	{
		float temp = values[i];
		values[i] = values[ij];
		values[ij] = temp;
	}

	//descending
	if (ij > i && (i & k) != 0 && values[i] < values[ij])
	{
		float temp = values[i];
		values[i] = values[ij];
		values[ij] = temp;
	}
}

int cuda_sort(int number_of_elements, float* a)
{
	//limiting thread usage
	if(number_of_elements > 512)
		threads_ = 512;
	else
		threads_ = number_of_elements;

	blocks_ = number_of_elements/threads_;
	
	float *values;
	size_t size = number_of_elements * sizeof(float);

	cudaMalloc((void**) &values, size);
	cudaMemcpy(values, a, size, cudaMemcpyHostToDevice);

	dim3 threads(threads_, 1);
	dim3 blocks(blocks_, 1);

	for (int k = 2; k <= number_of_elements; k <<= 1) 
		for (int j=k>>1; j>0; j=j>>1) 
			bitonic_sort<<<blocks_, threads_>>>(values, j, k);
	
	cudaMemcpy(a, values, size, cudaMemcpyDeviceToHost);
	cudaFree(values);

	return 0;
}



#ifdef __cplusplus
}
#endif

