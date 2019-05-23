  // CSC456: Name -- 
  // CSC456: Student ID # --
  // CSC456: I am implementing -- Bitonic Sort
  // CSC456: Feel free to modify any of the following. You can only turnin this file.

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <sys/time.h>
#include <pthread.h>
#include "mysort.h"
#include "iostream"



int n;         
float *a;       
int ASCENDING = 1;
int DESCENDING = 0;

void compareAndSwap(int, int, int);
void * BS(void *);
void * BM(void *);
void merge(int, int, int);

typedef struct
{
    int lo, cnt, dir, layer;
}arr;

int pthread_sort(int num_of_elements, float *data)
{
    n=num_of_elements;
    a=data;
    arr x;
    x.lo = 0;
    x.cnt = n;
    x.dir = ASCENDING;
    x.layer = 0;
    BS(&x);
   
    data=a;
    return 0;
}


int desc( const void *a, const void *b )
{
    int* x1 = (int *)a;
    int* x2 = (int *)b;
    if( *x1 > *x2 ) return -1;
    else if( *x1 == *x2 ) return 0;
    return 1;
}

int asc( const void *a, const void *b )
{
    int* x1 = (int *)a;
    int* x2 = (int *)b;
    if( *x1 < *x2 ) return -1;
    else if( *x1 == *x2 ) return 0;
    return 1;
}


void * BS(void * x)
{
    int lo = ((arr *)x)->lo;
    int cnt = ((arr *)x)->cnt;
    int dir = (( arr *) x)->dir;
    int layer = ((arr*)x)->layer;
    if(cnt > 1)
    {
        int k = cnt/2;
        
        //limiting the thread creation to two threads
	//After many values threads limited to 2 gave the best performance
        if(layer >= 1)
        {
            qsort(a+lo, k, sizeof(int), asc);
            qsort(a+(lo+k), k, sizeof(int), desc);
        }
        else
        {
            //Thread for ascending
            arr x1;
            pthread_t thread1;
            x1.lo = lo;
            x1.cnt = k;
            x1.dir = ASCENDING;
            x1.layer = layer + 1;
            pthread_create( &thread1, NULL, BS, &x1 );
            
            //Thread for descending
            arr x2;
            pthread_t thread2;
            x2.lo = lo + k;
            x2.cnt = k;
            x2.dir = DESCENDING;
            x2.layer = layer + 1;
            pthread_create( &thread2, NULL, BS, &x2 );
            
            
            pthread_join( thread1, NULL );
            pthread_join( thread2, NULL );
        }
        
        //call bitonic merge
        arr x3;
        x3.lo = lo;
        x3.cnt = cnt;
        x3.dir = dir;
        x3.layer = 1-layer;
        BM(&x3);
        //merge(lo,cnt,dir);
    }
}
void * BM(void * x)
{
    int lo = (( arr * )x) -> lo;
    int cnt = (( arr * )x) -> cnt;
    int dir = (( arr * )x) -> dir;
    int layer = (( arr * )x) -> layer;
    if( cnt > 1 )
    {
        int k = cnt / 2;
        int i;
        for(i = lo; i < lo + k; i++)
            compareAndSwap(i, i + k, dir);
        
        if(layer <= 0)
        {
            merge(lo, k, dir);
            merge(lo + k, k, dir);
            return 0;
        }
    
        arr arg1, arg2;
        pthread_t thread1, thread2;
        arg1.lo = lo;
        arg1.cnt = k;
        arg1.dir = dir;
        arg1.layer = layer - 1;
        arg2.lo = lo + k;
        arg2.cnt = k;
        arg2.dir = dir;
        arg2.layer = layer - 1;
        BM(&arg1);
        BM(&arg2);
     
     }
    return 0;
}

void compareAndSwap(int i, int j, int dir) 
{
    float t;
    if (dir==(a[i]>a[j]))
    {
        t = a[i];
        a[i] = a[j];
        a[j] = t;
        
    }
}

void merge(int lo, int cnt, int dir)
{
    if (cnt>1) 
    {
        int k=cnt/2;
        int i;
        for (i=lo; i<lo+k; i++)
            compareAndSwap(i, i+k, dir);
        merge(lo, k, dir);
        merge(lo+k, k, dir);
    }
}
