extends Particles2D

onready var rc = $RayCast2D 


func _ready() -> void:
	var startDegrees := -22.0
	var endDegrees := 57.0
	var startDist := 120.0
	var endDist := 150.0
	
	var splats:int = rand_range(3, 8)
	for i in splats:
		var prcnt = float(i) / float(splats)
		
		# Getting the positioning values.
		var degrees = ((endDegrees - startDegrees) * prcnt) + startDegrees
		var dist = ((endDist - startDist) * prcnt) + startDist
		print(degrees)
		rc.cast_to = Vector2(dist,0).rotated(deg2rad(degrees))
		rc.force_raycast_update()
		if rc.is_colliding():
			var sprite = Sprite.new()
			sprite.texture = preload("res://Entities/Effects/Blood/Splatter.png")
			sprite.flip_h = Utils.coin_flip()
			sprite.hframes = 2
			sprite.frame = rand_range(0, 1)
			sprite.centered = false
			sprite.z_index = 2
			sprite.modulate = Color("#f5f85959")
			sprite.position = rc.get_collision_point().round()#.snapped(Vector2.ONE * 16)
			sprite.rotation = rc.get_collision_normal().angle() + (PI / 2)
			GameManager.spawnManager.spawn_object(sprite)
