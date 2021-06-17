extends TextureRect

var moveSpeed = 12
var moveDir = Vector2.UP
var scaleSpeed = .5
var lifetime = 6

var player : Node2D

var targetScale = rand_range(.5, 2)


func _process(delta):
	rect_position += moveDir*(moveSpeed*delta)
	var dist = rect_global_position.distance_to(player.global_position)
	modulate.a = clamp(1-(dist/200), 0, 1)

	rect_scale = rect_scale.move_toward(Vector2(targetScale, targetScale), scaleSpeed*delta)

	targetScale = rand_range(.5, 2) if rect_scale.is_equal_approx(Vector2(targetScale, targetScale)) else targetScale


func set_param(color:Color, strength:float):
	material.set_shader_param("lightColor", color)
	material.set_shader_param("strength", strength)
