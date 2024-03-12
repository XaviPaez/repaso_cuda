__global__ void suma_vectores(const float *a, const float *b,   float*resultado, int tamanio){

    int index = blockIdx.x * blockDim.x + threadIdx.x;

    if(index<tamanio){
        resultado[index] = a[index]+b[index];
    }

}

extern "C" void suma(const float *a, const float *b,   float*resultado, int tamanio) {
    //kernel
    int thr_per_blk = 1024;//256;
    int blk_in_grid = ceil( float(width*height) / thr_per_blk );

    kerbel_bordes_image<<<blk_in_grid,thr_per_blk>>>(src_image, dst_image, width, height);
}

