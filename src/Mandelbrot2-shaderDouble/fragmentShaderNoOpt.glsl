#version 430

out vec4 color;
uniform int MAX_ITER;
uniform vec2 u_resolution;
uniform float move_x;
uniform float move_y;
uniform float zoom; 

/* Algoritmo "Escape Time" */
int Mandelbrot(float x, float y){
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

void main(void) {
    float scale = 0.2;
    vec2 c;
    c = (gl_FragCoord.xy / u_resolution.xy - vec2(0.5, 0.5)); // normalizar y establecer origen en centro de la pantalla
    c = c/(zoom*scale);
    c = c + vec2(-move_x, -move_y); // aplica movimiento 
    int count_iter = Mandelbrot(c.x, c.y);
    float percent = float(count_iter)/float(MAX_ITER);
    color.x = percent * 4.0 * (1.9-percent) * (1-percent) * (1-percent) * percent;
    color.y = percent * 3.0 * (1.6-percent) * (1-percent) * (1-percent);
    color.z = percent * 7.0 * (1.3-percent) * (1-percent);
    color.w = 1.0;
}