#ifdef GL_ES
precision highp float;
#endif

varying vec4 ps_color;

void main() 
{
	gl_FragColor = ps_color;
	if (gl_FragColor.w == 0.0)
		discard;
}
