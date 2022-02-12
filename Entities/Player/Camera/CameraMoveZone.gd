extends Area2D

export var mouseLook = true

onready var collisionShape = $CollisionShape2D

signal camFocused 


func _on_area_entered(area):
	if area.is_in_group("player"):
		var shapeExtents = collisionShape.shape.extents
		
		var cam = GameManager.currentCamera
		var limits = Rect2()
		limits.position.x = global_position.x-shapeExtents.x
		limits.position.y = global_position.y-shapeExtents.y
		limits.end.x = global_position.x+shapeExtents.x
		limits.end.y = global_position.y+shapeExtents.y
		cam.limits = limits
		$SoundManager.play()
		
		emit_signal("camFocused")
