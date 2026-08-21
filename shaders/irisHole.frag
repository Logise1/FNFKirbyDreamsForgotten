#pragma header

uniform float radius;
uniform float feather;
uniform float aspect;

void main() {
	vec2 uv = openfl_TextureCoordv;
	vec2 p = vec2((uv.x - 0.5) * aspect, uv.y - 0.5);
	float dist = length(p);
	float a = smoothstep(radius - feather, radius + feather, dist);
	gl_FragColor = vec4(0.0, 0.0, 0.0, a);
}
