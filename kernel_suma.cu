#include <iostream>

/*
 std::vector<sf::Uint8> sumaImagen_Serial(const sf::Uint8* imagen, const sf::Uint8* imagen2, int with, int height){

    std::vector<sf::Uint8> buffer(with*height*4);
    for(int i= 0; i<height; i++){
        for(int j =0; j<with; j++){

            int index= (i*with+j)*image_channels;
            buffer[index] = (imagen[index]+ imagen2[index])/2;
            buffer[index+1] = (imagen[index+1]+ imagen2[index+1])/2;
            buffer[index+2] = (imagen[index+2]+ imagen2[index+2])/2;;
            buffer[index+3] = 255;


        }

    }
    return buffer;
}
 */

__global__ void kernel_sum(unsigned char* image,unsigned char* image2, unsigned char*
dst_image, int width, int height){

    int index = blockDim.x*blockIdx.x + threadIdx.x;


    int y = index/width;
    int x = index % width;

    int posicion = (y*width+x)*4;

    dst_image[posicion] = (image[posicion]+ image2[posicion])/2;
    dst_image[posicion+1] = (image[posicion+1]+ image2[posicion+1])/2;
    dst_image[posicion+2] = (image[posicion+2]+ image2[posicion+2])/2;;
    dst_image[posicion+3] = 255;



}
extern "C" void kernel_sum_ex(unsigned char* src_image, unsigned char* src_image2, unsigned char* dst_image, int width, int height) {
    //kernel
    int thr_per_blk = 1024;//256;
    int blk_in_grid = ceil( float(width*height) / thr_per_blk );

    kernel_sum<<<blk_in_grid,thr_per_blk>>>(src_image, src_image2, dst_image, width, height);
}