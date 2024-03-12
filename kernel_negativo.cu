
#include <iostream>


__global__ void kernel_neagtivo(unsigned char* image, unsigned char* dst_image, int width, int height ){

    int index = blockDim.x*blockIdx.x + threadIdx.x;
    int pix_y = index / width;
    int pix_x = index % width;

    int id = (pix_y*width+pix_x)*4;

    dst_image[id] = 255- image[id];
    dst_image[id+1] = 255- image[id+1];
    dst_image[id+2] = 255- image[id+2];
    dst_image[id+3] = 255;

}
extern "C" void kernel_negativo_ex(unsigned char* src_image, unsigned char* dst_image, int width, int height) {
    //kernel
    int thr_per_blk = 1024;//256;
    int blk_in_grid = ceil( float(width*height) / thr_per_blk );

    kernel_neagtivo<<<blk_in_grid,thr_per_blk>>>(src_image, dst_image, width, height);
}