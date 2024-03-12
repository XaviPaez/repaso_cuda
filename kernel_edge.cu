#include <stdio.h>

#define image_channels 4


__global__ void kerbel_bordes_image(unsigned char* src_image, unsigned char* dst_image, int width, int height) {

    int index = blockDim.x*blockIdx.x + threadIdx.x;

    int pix_y = index / width;
    int pix_x = index % width;


    int r = 0;
    int g = 0;
    int b = 0;
    int cc = 0;

    int matriz[] = { 0, 1, 0, 1, -4, 1, 0, 1, 0 };

    for(int i=-1;i<=1;i++) {
        for(int j=-1;j<=1;j++) {
            int index = (pix_y * width + pix_x)*image_channels + (i * 4) + (j * width * 4);

            if(index >= 0 && index <= width * height * image_channels) {
                int matrixIndex = (i + 1) * 3 + (j + 1);
                int weight = matriz[matrixIndex];

                r += src_image[index] * weight;
                g += src_image[index + 1] * weight;
                b += src_image[index + 2] * weight;
            }
        }
    }

    int index_final = (pix_y * width + pix_x)*image_channels;
    r = max(0,min(r,255));
    g = max(0,min(g,255));
    b = max(0,min(b,255));

    dst_image[index_final+0] = r;
    dst_image[index_final+1] = g;
    dst_image[index_final+2] = b;
    dst_image[index_final+3] = 255;
}

extern "C" void kernel_bordes(unsigned char* src_image, unsigned char* dst_image, int width, int height) {
    //kernel
    int thr_per_blk = 1024;//256;
    int blk_in_grid = ceil( float(width*height) / thr_per_blk );

    kerbel_bordes_image<<<blk_in_grid,thr_per_blk>>>(src_image, dst_image, width, height);
}