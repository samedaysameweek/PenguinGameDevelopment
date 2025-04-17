// Fragment Shader (shd_blur.fsh)
varying vec2 v_vTexcoord;
uniform sampler2D texture;

const float blurSize = 1.0 / 512.0;

void main()
{
    vec4 sum = vec4(0.0);

    // Blur in the y (vertical) direction
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y - 4.0 * blurSize)) * 0.05;
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y - 3.0 * blurSize)) * 0.09;
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y - 2.0 * blurSize)) * 0.12;
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y - blurSize)) * 0.15;
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y)) * 0.16;
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y + blurSize)) * 0.15;
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y + 2.0 * blurSize)) * 0.12;
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y + 3.0 * blurSize)) * 0.09;
    sum += texture2D(texture, vec2(v_vTexcoord.x, v_vTexcoord.y + 4.0 * blurSize)) * 0.05;

    gl_FragColor = sum;
}