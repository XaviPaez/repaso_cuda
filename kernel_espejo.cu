#include <iostream>


__global__ void kernel_espejo(unsigned char* image, unsigned char* dst_image, int width, int height ){

    int index = blockDim.x*blockIdx.x + threadIdx.x;
    int pix_y = index / width;
    int pix_x = index % width;

    int start =(pix_y*width*4);
    int end = start+(width-1)*4;
    int condicion = end;
    while (start < condicion) {
        dst_image[start] = image[end - 4];
        dst_image[start + 1] = image[end - 3];
        dst_image[start + 2] = image[end - 2];
        dst_image[start + 3] = image[end-1];
        start += 4;
        end -= 4;
    }
}
extern "C" void kernel_espejo_ex(unsigned char* src_image, unsigned char* dst_image, int width, int height) {
    //kernel
    int thr_per_blk = 1024;//256;
    int blk_in_grid = ceil( float(width*height) / thr_per_blk );

    kernel_espejo<<<blk_in_grid,thr_per_blk>>>(src_image, dst_image, width, height);
}