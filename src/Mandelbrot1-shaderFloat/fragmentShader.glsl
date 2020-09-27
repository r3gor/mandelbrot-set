#version 430

out vec4 color;
uniform int MAX_ITER;
uniform vec2 u_resolution;
uniform float move_x;
uniform float move_y;
uniform float zoom; 
uniform int op;

const vec3 color_map[] = {
    {0.0,  0.0,  0.0},
    {0.26, 0.18, 0.06},
    {0.1,  0.03, 0.1},
    {0.04, 0.0,  0.18},
    {0.02, 0.02, 0.29},
    {0.0,  0.03, 0.39},
    {0.05, 0.17, 0.54},
    {0.09, 0.32, 0.69},
    {0.22, 0.49, 0.82},
    {0.52, 0.71, 0.9},
    {0.82, 0.92, 0.97},
    {0.94, 0.91, 0.75},
    {0.97, 0.79, 0.37},
    {1.0,  0.67, 0.0},
    {0.8,  0.5,  0.0},
    {0.6,  0.34, 0.0},
    {0.41, 0.2,  0.01}
};

/* Algoritmo "Escape Time"*/
int Mandelbrot1(float x, float y){
    int contIter = 0;
    float k = 0;
    float w = 0;
    while(contIter < MAX_ITER && k*k + w*w <= 4){
        float actK = k;
        k = k*k - w*w + x;
        w = 2*actK*w + y;
        contIter = contIter + 1;
    }
    return contIter;
}

/* Algoritmo "Escape Time" optimizado */
int Mandelbrot2(const float x, const float y){
    int contIter = 0;
    float k = 0;
    float w = 0;
    float kCuad = 0.0;
    float wCuad = 0.0;
    while(contIter < MAX_ITER && kCuad + wCuad <= 4){
        w = (w+w)*k + y;
        k = kCuad - wCuad + x;
        kCuad = k*k;
        wCuad = w*w;
        contIter = contIter + 1;
    }
    return contIter;
}

void main(void) {
    float scale = 0.2;
    vec2 c;
    c = (gl_FragCoord.xy / u_resolution.xy - vec2(0.5, 0.5)); // normalizar y establecer origen en centro de la pantalla
    c = (c/zoom);
    c = (c/scale);
    c = c + vec2(-move_x, -move_y); // aplica movimiento 

    if (op==1){
        const int count_iter = Mandelbrot1(c.x, c.y);
        float percent = float(count_iter)/float(MAX_ITER);
        color.x = float (percent * 4.0 * (1.9-percent) * (1-percent) * (1-percent) * percent);
        color.y = float(percent * 3.0 * (1.6-percent) * (1-percent) * (1-percent));
        color.z = float(percent * 7.0 * (1.3-percent) * (1-percent));
    }
    if (op==2){
        const int count_iter = Mandelbrot2(c.x, c.y);
        float percent = float(count_iter)/float(MAX_ITER);
        color.z = float (percent * 4.0 * (1.9-percent) * (1-percent) * (1-percent) * percent);
        color.y = float(percent * 3.0 * (1.6-percent) * (1-percent) * (1-percent));
        color.x = float(percent * 7.0 * (1.3-percent) * (1-percent));
    }
    if (op==3){
        const int count_iter = Mandelbrot1(c.x, c.y);
        if(count_iter != MAX_ITER){
            const uint row_index = (count_iter * 100 / MAX_ITER % 17);
            color.xyz = color_map[row_index];
        } else {
            color.xyz = vec3(0.0);
        }
    }
    if (op==4){
        const int count_iter = Mandelbrot2(c.x, c.y);
        if(count_iter != MAX_ITER){
            const uint row_index = (count_iter * 100 / MAX_ITER % 17);
            color.xyz = color_map[row_index];
        } else {
            color.xyz = vec3(0.0);
        }
    }
    color.w = 1.0;
}