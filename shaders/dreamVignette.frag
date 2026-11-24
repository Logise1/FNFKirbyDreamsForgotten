#pragma header

uniform float amount;

void main() {
	vec2 uv = getCamPos(openfl_TextureCoordv);
	vec4 col = textureCam(bitmap, uv);
	float d = distance(uv, vec2(0.5, 0.5));
	float vig = 1.0 - d * d * amount;
	col.rgb *= vig;
	gl_FragColor = vec4(col.rgb, col.a);
}
