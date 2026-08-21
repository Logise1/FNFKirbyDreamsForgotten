#pragma header

uniform float uTime;
uniform float uStrength;
uniform float uSpeed;

void main() {
	vec2 uv = openfl_TextureCoordv;
	float t = uTime * uSpeed;
	float wave = sin(uv.y * 24.0 + t) * uStrength;
	float wave2 = cos(uv.x * 16.0 + t * 0.65) * uStrength * 0.45;
	uv.x += wave;
	uv.y += wave2 * 0.35;
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
	} else {
		gl_FragColor = flixel_texture2D(bitmap, uv);
	}
}
