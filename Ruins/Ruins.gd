extends StaticBody2D
class_name Ruin

var worldGenerator
var chunk : Vector2
onready var sprite = $Sprite
onready var queueCollision = $QueueCollision


func _process(_delta):
	if global_position.distance_to(worldGenerator.player.global_position) >= (10*16)*3:
		worldGenerator.get_parent().ruinedChunks.erase(chunk)
		queue_free()


func set_color(color):
	if !is_inside_tree():
		return
	if get_tree():
		sprite.material.set_shader_param("newColor", color)
		var scales = [1, -1]
		scale.x = scales[rand_range(0, 1)]


func _on_QueueCollision_body_entered(body):
	if body is TileMap or (body.is_in_group("ruin") and body != self):
		queue_free()
