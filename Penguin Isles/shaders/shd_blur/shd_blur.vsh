// Vertex Shader (shd_blur.vsh)
attribute vec2 in_Position;
attribute vec2 in_TextureCoord;
varying vec2 v_vTexcoord;

void main()
{
    v_vTexcoord = in_TextureCoord;
    gl_Position = vec4(in_Position, 0.0, 1.0);
}