extends Node
class_name RoomLockIn

onready var world = get_parent()

export var yieldFrames = 1
export var automaticRemoval := false


func _init() -> void:
	set_meta("set_under_root", true)

func _ready() -> void:
	yield(TempTimer.idle_frame(self, yieldFrames + 1), "timeout")
	world = get_parent()
	world.automaticBlockRemoval = automaticRemoval
	create_block_offs()


func remove_blocks() -> void:
	world._on_enemies_cleared(true)


func create_block_offs() -> void:
	# Blocking off exits
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
	for i in dirs:
		var blockOff := preload("res://World/Props/DoorBlock/DoorBlock.tscn").instance()
		var collisionShape := RectangleShape2D.new()

		var extents:Vector2 = world.solids.get_used_rect().end
		match i:
			Vector2.UP:
				var collisionSize = (extents.x*.5)*world.solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)

				blockOff.scale.x = -1
				blockOff.rotation_degrees = 90
				blockOff.position = Vector2((extents.x*.5), 0)
			Vector2.DOWN:
				var collisionSize = (extents.x*.5)*world.solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)

				blockOff.rotation_degrees = 90
				blockOff.position = Vector2((extents.x*.5), extents.y)
			Vector2.RIGHT:
				var collisionSize = (extents.y*.5)*world.solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)

				blockOff.position = Vector2(extents.x, (extents.y*.5))
			Vector2.LEFT:
				var collisionSize = (extents.y*.5)*world.solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)

				blockOff.scale.x = -1
				blockOff.position = Vector2(0, (extents.y*.5))

		add_child(blockOff)
		blockOff.position *= world.solids.cell_size
		blockOff.position = blockOff.position.round()
		blockOff.collision.shape = collisionShape
		blockOff.position_sprite()

		world.exitBlockers.append(blockOff)
