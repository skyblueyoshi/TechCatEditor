attribute vec3 vs_position;
attribute vec3 vs_normal;
attribute vec2 vs_texCoords;

uniform mat4 mat_model;
uniform mat4 mat_vp;

varying vec3 ps_fragPos;
varying vec3 ps_normal;
varying vec2 ps_texCoords;

void main() 
{
	ps_fragPos = vec3(mat_model * vec4(vs_position, 1.0));
	//ps_normal = mat3(transpose(inverse(mat_model))) * vs_normal;
	ps_normal = vs_normal;
	ps_texCoords = vs_texCoords;

	gl_Position = mat_vp * vec4(ps_fragPos, 1);
	gl_Position.x = -gl_Position.x;
}
