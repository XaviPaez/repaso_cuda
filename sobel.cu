#include <iostream>


__global__ void kernel_sobel(unsigned char* image, unsigned char* dst_image, int width, int height ){

    int index = blockDim.x*blockIdx.x + threadIdx.x;
    int pix_y = index / width;
    int pix_x = index % width;

    int r_x = 0;
    int g_x = 0;
    int b_x = 0;

    int r_y = 0;
    int g_y = 0;
    int b_y = 0;

    int sobel_x[] = { -1, 0, 1, -2, 0, 2, -1, 0, 1 };
    int sobel_y[] = { -1, -2, -1, 0, 0, 0, 1, 2, 1 };

    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            int index = ((pix_y* width + pix_x) * 4) + (i * 4) + (j * width * 4);

            if (index >= 0 && index <= width * height * 4) {
                int matrixIndex = (i + 1) * 3 + (j + 1);

                int weight_x = sobel_x[matrixIndex];
                int weight_y = sobel_y[matrixIndex];

                r_x += image[index] * weight_x;
                g_x += image[index + 1] * weight_x;
                b_x += image[index + 2] * weight_x;

                r_y += image[index] * weight_y;
                g_y += image[index + 1] * weight_y;
                b_y += image[index + 2] * weight_y;
            }
        }
    }

    int r = min(max(abs(r_x)+ abs(r_y)/2, 0), 255);
    int g =  min(max(abs(g_x)+ abs(g_y)/2, 0), 255);
    int b =  min(max(abs(b_x)+ abs(b_y)/2, 0), 255);

    int posicion = (pix_y*width+pix_x)*4;


    dst_image[posicion] = r;
    dst_image[posicion + 1] = g;
    dst_image[posicion + 2] = b;
    dst_image[posicion + 3] = 255;




}
extern "C" void kernel_sobel_ex(unsigned char* src_image, unsigned char* dst_image, int width, int height) {
    //kernel
    int thr_per_blk = 1024;//256;
    int blk_in_grid = ceil( float(width*height) / thr_per_blk );

    kernel_sobel<<<blk_in_grid,thr_per_blk>>>(src_image, dst_image, width, height);
}