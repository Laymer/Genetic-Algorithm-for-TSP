
#ifndef __CUDACC__
#define __CUDACC__
#endif // __CUDACC__
#include<time.h>
#include<stdio.h>
#include<stdlib.h>
#include<conio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

/*__global__ void print(int *city,int n)
{
	int j=0;
	int i=threadIdx.x;
	if(i<256)
	{   j++; 
	for(int k=0;k<n;k++)
	{
		printf("%d(%d)",i,city[i*n+k]);
	}}

}
/*__global__ void print (int *a,int n)
{
	int i=threadIdx.x;
	int row=i/4;
		int col=i%4;

	if(i<n)
	{
		
			printf("%d", a[row*4+col]);
			printf("%d,%d\n ",row,col);


	}

}
*/
__global__ void genetic( int n,int *city,int *b, int *f,int c,int *a   )
{

int  i=threadIdx.x+blockIdx.x*blockDim.x;
//time_t begin;
//if(i==0)
//{


//begin=time(NULL);
//printf("CPU start time is : %d \n" ,cpu_time_1);
//}
int j=0;
int t=blockDim.x;

int r,flag,flag1,flag2,count,l,k,k1=0,dist=0,min,max,minid,criteria=0;
r=(i)%n;
while(j<n)
{
r=(r+1)%n;
flag=0;
for(k=0;k<k1;k++)
{
if((city[(i*n)+k])==r)
    {
    flag=1;
    break;
    }

}

    if(flag==0)
    {
        city[(i*n)+j]=r;
        j=j+1;
		k1=k1+1;
    }
}
//for(k=0;k<n;k++)
//{
	//printf("(%d)%d\n",i,city[(i*n)+k]);
//}



flag=0;
count=0;
int count1=0;

count=0;

	
	
while(count<c)
{
	
	dist=0;
for(j=0;j<n-1;j++)
{
   dist+=a[((city[i*n+j])*n)+(city[(i*n)+j+1])];
}
//printf("%d(%d)%d",dist,i,count);
b[i]=dist;
min=999;max=0;
if(f[i]==1)
{
b[i]=999;
}
__syncthreads();

for(k=0;k<n;k++)
{
    if(b[k]<min && f[k]==0)
    {
       min=b[k];
       minid=k;
    }
    if(b[k]>max && f[k]==0)
    {
       max=b[k];

    }
}

criteria=(min+max)/2;
if(b[i]>criteria)
{
    flag=1;
    f[i]=1;
    b[i]=999;

}

flag2=0;
if(i!=minid)
{

while(flag2==0)
{

    r=(r+1)%t;
    if(f[r]==0)
    {

        flag2=1;
        k=n/2;


            for(j=0;k<n;j++)
            {   flag1=0;
                for(l=0;l<k;l++)
                {
                    if(city[r*n+j]==city[i*n+l])
                    {
                        
                        flag1=1;
                        break;
                    }
                }
                if(flag1==0)
                {
                    city[i*n+k]=city[r*n+j];
                    k++;

                }
            }


		
        }


}

}
//for(k=0;k<n;k++)
//{
	//printf("(%d)%d%d\n",i,city[(i*n)+k],count);
//}
count=count+1;

}
//if(i==0)
//{

//clock_t cpu_time_2=clock();
//printf("CPU end time is : %d \n" ,cpu_time_2);
	//time_t e;
//e=time(NULL);
//printf("\n time taken is %f \n",difftime(e,begin));
//}
if(i<n)
{
	city[0*n+i]=city[minid*n+i];
	b[0]=b[minid];
	printf("%d(%d)",city[0*n+i],i);
}
}

void main()
{
    int i=0,j=0,n=0,cost[10*10],*city,*b,*f,c=0,t=0,*a;
    printf("Enter the number of cities");
    scanf("%d",&n);
	n=10;
    printf("Enter the cost matrix");
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            if(j==i+1)
            {
                cost[i*n+j]=1;

            }
            else if(i==j)
            {
                cost[i*n+j]=0;

            }
            else
                cost[i*n+j]=4;
           // scanf("%d",&a[i][j]);

        }
    }
	//for(i=0;i<n;i++)
    //{
      //  for(j=0;j<n;j++)
        //{
          //  printf("%d",cost[i*n+j]);

        //}
    //}
    int bd[1000]={0};
    int fd[1000]={0};
	int city1[1000*20]={100};
	
    printf("Enter the count");
   // scanf("%d",&c)
    c=100;
	printf("Enter the number of threads");
    //scanf("%d",&t);
	t=400;
    int size1=t*(sizeof(int));
    int size=t*n*(sizeof(int));
	int size2=n*n*(sizeof(int));
	cudaEvent_t start,stop;
	float time;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	cudaMalloc((void**)&a,size2);
    cudaMemcpy(a,cost,size2,cudaMemcpyHostToDevice);
    cudaMalloc((void**)&city,size);
    cudaMalloc((void**)&b,size1);
    cudaMalloc((void**)&f,size1);
 //cudaMemcpy(city,city1,size,cudaMemcpyHostToDevice);
    //cudaMemcpy(b,bd,size1,cudaMemcpyHostToDevice);
    //cudaMemcpy(f,fd,size1,cudaMemcpyHostToDevice);
	//..cudaEventRecord(start,0);
     genetic<<<1,400>>>(n,city,b,f,c,a);
	 //cudaEventRecord(start,0);
	 //cudaEventSynchronize(stop);
	//print<<<1,t>>>(city,n);
     cudaMemcpy(bd,b,(sizeof(int)),cudaMemcpyDeviceToHost);
     size=n*(sizeof(int));
	 int city2[100];
    cudaMemcpy(city2,city,(n*(sizeof(int))),cudaMemcpyDeviceToHost);
	 //for(i=0;i<t;i++)
	 //{printf("%d",bd[i]);
	 //}
	 
     //int min=999;
     //int minid;
     //for(i=0;i<n;i++)
     //{
       //  if(bd[i]<min)
         //{
           //  minid=i;
             //min=bd[i];
         //}
     //}
	 //for(i=0;i<t;i++)
	// {
		// for(j=0;j<n;j++)
		 //{
		 //printf("%d",city1[t*n+j]);
		 //}}
     printf("\n Min distance using genetic algorithm is %d",bd[0]);
     //printf("\n Path is \n\n");
     //for(i=0;i<n;i++)
     //{
       //  printf("%d->",city2[i]);
     //}
	 cudaFree(city);
	 cudaFree(b);
	 cudaFree(f);
	 cudaFree(a);
	 //cudaEventElapsedTime(&time,start,stop);
	 //printf("\n\n time taken for kernel %f ms\n",time);
	 getch();
}
