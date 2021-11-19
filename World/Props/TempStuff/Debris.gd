extends Node2D
class_name Debris

export var sprite: StreamTexture


func _ready() -> void:
	var timer = get_tree().create_timer(3)
	timer.connect("timeout", self, "queue_free")
	
	update()


func _process(delta: float) -> void:
	rotation += delta*3
	position.y += Globals.GRAVITY*delta*.25


func _draw() -> void:
	if sprite:
		draw_texture(sprite, -sprite.get_size()*.5)
