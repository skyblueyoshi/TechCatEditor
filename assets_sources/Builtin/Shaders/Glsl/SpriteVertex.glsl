attribute vec3 vs_position;
attribute vec4 vs_color;
attribute vec2 vs_uv;

uniform mat4 mat_mvp;
uniform vec2 pos_fix;

varying vec2 ps_uv;
varying vec4 ps_color;

void main() 
{
	ps_uv = vs_uv;
	ps_color = vs_color;
	gl_Position = mat_mvp * vec4(vs_position, 1);
	gl_Position.x = -gl_Position.x;
	//gl_Position.z = gl_Position.z * 2.0 - 1.0;
	gl_Position.y = gl_Position.y * pos_fix.y;
}