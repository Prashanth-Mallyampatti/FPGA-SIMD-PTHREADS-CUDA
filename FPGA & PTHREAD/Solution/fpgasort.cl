__kernel void fpgasort(__global float *a, __global int *num) 
{
    // get index of the work item
    int index = get_global_id(0);
    int offset = *num/get_global_size(0);
    int start_index = index*offset;
	int high = start_index + offset;
	int low = start_index;
int i,j,k;
  float t;
  for (k=2; k<=high; k=k<<1)
  {
    for (j=k>>1; j>0; j=j>>1)
    {
      for (i=low; i<high; i++)
      {
          int ij=i^j;
          if ((ij>i) && (((i&k)==0 && a[i] > a[ij]) || ((i&k)!=0 && a[i] < a[ij])))
          {
                t = a[i];
                a[i] = a[ij];
                a[ij] = t;
          }
      }
    }
  }
}

