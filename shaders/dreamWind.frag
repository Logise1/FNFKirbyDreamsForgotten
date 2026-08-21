#pragma header

uniform float uTime;
uniform float uStrength;

void main() {
	vec2 uv = openfl_TextureCoordv;
	float sway = sin(uTime * 1.35 + uv.y * 7.0) * uStrength * (1.0 - uv.y);
	uv.x += sway;
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
	} else {
		gl_FragColor = flixel_texture2D(bitmap, uv);
	}
}
