shader_type canvas_item;
render_mode blend_mix,unshaded;

void fragment()
{
	vec4 sprite_color = texture(TEXTURE, UV);
	
	float d = distance(UV, vec2(0.5, 0.5));
	d -= 0.5;
	d = d * 0.05;
	vec4 warp_color = texture(SCREEN_TEXTURE, SCREEN_UV + d);
	
	vec4 real_sprite_color = sprite_color;
	if (sprite_color == vec4(0,0,0,1)) real_sprite_color.a = 0.0;
	COLOR = mix(warp_color, real_sprite_color, sprite_color.a);
}