shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = .0;

vec4 get_grayscale(vec4 color) {
	float scale = 3.0;
	vec4 newColor = vec4(0.0, 0.0, 0.0, 1.0);
	float grayVal = (color.r+color.g+color.b)/scale;
	newColor.r = grayVal;
	newColor.g = grayVal;
	newColor.b = grayVal;
	
	return newColor;
}

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR = mix(get_grayscale(color), color, strength);
}
