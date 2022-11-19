attribute vec3 vs_position;
attribute vec3 vs_normal;

uniform mat4 mat_mvp;

void main() 
{
	gl_Position = mat_mvp * vec4(vs_position, 1);
	//gl_Position.z = gl_Position.z * 2.0 - 1.0;
}
