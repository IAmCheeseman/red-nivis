extends Node2D

onready var rc = $RayCast2D

export var bloodColor: Color = Color("#f5f85959")
export var startDegrees := -90.0
export var endDegrees := 90.0
export var startDist := 150.0
export var endDist := 150.0
export var splatRange := Vector2(3, 8)


func _ready() -> void:
	var splats:int = int(rand_range(splatRange.x, splatRange.y))
	for i in splats:
		var prcnt = float(i) / float(splats)

		# Getting the positioning values.
		var degrees = ((endDegrees - startDegrees) * prcnt) + startDegrees
		var dist = ((endDist - startDist) * prcnt) + startDist
		rc.cast_to = Vector2(dist,0).rotated(deg2rad(degrees))
		rc.force_raycast_update()
		if rc.is_colliding():
			var tilemap: TileMap = GameManager.mainTileset
			var pos: Vector2 = tilemap.world_to_map(rc.get_collision_point())

			var add = Vector2.DOWN if rc.cast_to.y > 0 else Vector2.UP
			if tilemap.get_cellv(pos + add) == -1: continue

			# Checking if there's already some blood here
			if !tilemap.has_meta("BLOODS"): tilemap.set_meta("BLOODS", [])
			if tilemap.get_meta("BLOODS").count(pos) >= 2: continue

			tilemap.get_meta("BLOODS").append(pos)

			var sprite = Sprite.new()
			sprite.texture = preload("res://Entities/Effects/Blood/Splatter.png")
			sprite.hframes = 4
			sprite.frame = rand_range(0, sprite.hframes)
			sprite.centered = false
			sprite.offset.y = 1
			sprite.z_index = 2
			sprite.modulate = bloodColor
			sprite.position = tilemap.map_to_world(pos)
			sprite.rotation = rc.get_collision_normal().angle() + (PI / 2)
			GameManager.spawnManager.spawn_object(sprite)

