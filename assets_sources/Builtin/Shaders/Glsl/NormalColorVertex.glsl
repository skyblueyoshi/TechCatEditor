attribute vec3 vs_position;
attribute vec4 vs_color;

uniform mat4 mat_mvp;
uniform vec2 pos_fix;

varying vec4 ps_color;

void main() 
{
	ps_color = vs_color;
	gl_Position = mat_mvp * vec4(vs_position, 1);
	//gl_Position.z = gl_Position.z * 2.0 - 1.0;
	gl_Position.y = gl_Position.y * pos_fix.y;
}


// class PosColor:
// 	vec3 pos
// 	vec4 color

// def vec4 mvp_calc(mat4 mat_mvp, vec3 pos):
// 	return mat_mvp * vec4(pos, 1)

// in PosColor vex
// in vec2 uv
// cbuffer mat4 mvp
// sampler tex_sampler

// def pass(1):
// 		_vs_pos = mvp_calc(mvp, vex.pos)
// 		_ps_color = vex.color	

// def pass(2):
// 		_vs_pos = _vs_last_pos
// 		_ps_color = _ps_last_color * texture2D(tex_sampler, uv)

// def pass(3):
// 		_ps_color = _ps_last_color * 0.5

// def pass(4):
// 		_vs_pos = _vs_last_pos + vec4(1,1,1,1)