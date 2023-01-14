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


func remove_blocks() -> void:
	world._on_enemies_cleared(true)




