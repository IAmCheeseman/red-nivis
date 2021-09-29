shader_type canvas_item;
render_mode blend_mix;

uniform float sway = 12;
uniform float strength = 8;

varying float x;

void vertex() {
	float time = sin(TIME*strength)*sway;
	VERTEX.x += time*UV.y;
}