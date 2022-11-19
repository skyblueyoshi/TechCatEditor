#ifdef GL_ES
precision highp float;
#endif

varying vec2 ps_uv;
varying vec4 ps_color;
uniform sampler2D tex_sampler;

void main() 
{
	gl_FragColor = ps_color * texture2D(tex_sampler, ps_uv);
	if (gl_FragColor.w == 0.0)
		discard;
}
