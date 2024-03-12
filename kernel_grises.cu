
#include <iostream>


__global__ void kernel_grises(unsigned char* image, unsigned char* dst_image, int width, int height ){

    int index = blockDim.x*blockIdx.x + threadIdx.x;
    int pix_y = index / width;
    int pix_x = index % width;

    int id = (pix_y * width + pix_x) * 4;
    int escala_grises = image[id] * 0.299 + image[id + 1] * 0.587 + image[id + 2] * 0.114;
    dst_image[id] = escala_grises;
    dst_image[id + 1] = escala_grises;
    dst_image[id + 2] = escala_grises;
    dst_image[id + 3] = 255;

}
extern "C" void kernel_grises_ex(unsigned char* src_image, unsigned char* dst_image, int width, int height) {
    //kernel
    int thr_per_blk = 1024;//256;
    int blk_in_grid = ceil( float(width*height) / thr_per_blk );

    kernel_grises<<<blk_in_grid,thr_per_blk>>>(src_image, dst_image, width, height);
}