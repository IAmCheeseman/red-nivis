shader_type canvas_item;

// https://godotshaders.com/shader/2d-outline-stroke/


uniform vec4 line_color : hint_color = vec4(1);
uniform float line_thickness : hint_range(0, 10) = 1.0;

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;

	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	// Corners
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	
	outline = min(outline, 1.0);

	vec4 color = texture(TEXTURE, UV);

	vec3 rcolor = texture(TEXTURE, UV).rgb;
	if (rcolor == vec3(0.623529, 0.043137, 0.043137)) {
		color = vec4(1, 1, 1, 1);
	}

	COLOR = mix(color, line_color, outline - color.a);
}