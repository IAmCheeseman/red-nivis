extends Line2D

var rc: RayCast2D

func _ready() -> void:
	rc = RayCast2D.new()
	rc.enabled = true
	rc.cast_to = Vector2(1000, 0)
	
	add_child(rc)
	
	material = CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD

func _process(delta: float) -> void:
	clear_points()
	
	add_point(Vector2.ZERO)
	if rc.is_colliding():
		add_point(to_local(rc.get_collision_point()))
	else:
		add_point(rc.cast_to)
