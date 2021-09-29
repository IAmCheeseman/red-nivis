extends Sprite

onready var collision = $Detection/CollisionShape2D

var targetSway = 0
var slowDown = 2

func _ready() -> void:
	var shape = RectangleShape2D.new()
	var shapeVec = Vector2(texture.get_width()*.5, texture.get_height()*.5)
	shape.extents = shapeVec
	
	collision.shape = shape
	
	material = material.duplicate()


func _process(delta: float) -> void:
	material.set_shader_param("sway", lerp(material.get_shader_param("sway"), targetSway, slowDown*delta))
	if material.get_shader_param("sway") >= targetSway-.005:
		targetSway = 0
		slowDown = 2


func _on_area_entered(area: Area2D) -> void:
	targetSway = 4
	slowDown = 10

