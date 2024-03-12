#include <iostream>


__global__ void kernel_min(unsigned char* image, unsigned char* image2, int width, int height ){

    unsigned char r[9];
    unsigned char g[9];
    unsigned char b[9];
    int contador=0;

    int index = blockDim.x*blockIdx.x + threadIdx.x;
    int pix_y = index / width;
    int pix_x = index % width;

    for(int i=pix_x-1;i<=pix_x+1;i++) {
        for(int j=pix_y-1;j<=pix_y+1;j++) {
            int id = (j * width + i) * 4;

            if (i >= 0 && i < width && j >= 0 && j < height) {
                r[contador] = (image[id]);
                g[contador] = (image[id + 1]);
                b[contador] = (image[id + 2]);

                contador++;
            }
        }

    }
    unsigned int minR= r[0];
    unsigned int minG=  g[0];
    unsigned int minB = b[0];

    for(int i = 0; i < contador; i++  ){
        minR = min(minR, r[i]);
        minG = min(minG, g[i]);
        minB = min(minB, b[i]);
    }
    int index_final = (pix_y * width + pix_x) * 4;

    image2[index_final] = minR;
    image2[index_final + 1] = minG;
    image2[index_final + 2] = minB;
    image2[index_final + 3] = 255;


}
extern "C" void kernel_min_ex(unsigned char* src_image, unsigned char* dst_image, int width, int height) {
    //kernel
    int thr_per_blk = 1024;//256;
    int blk_in_grid = ceil( float(width*height) / thr_per_blk );

    kernel_min<<<blk_in_grid,thr_per_blk>>>(src_image, dst_image, width, height);
}