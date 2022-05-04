extends "res://Entities/NPC/NPC.gd"

onready var openChestJumpTimer = $OpenChestJump

export(NodePath) onready var chest = get_node(chest)
export var jumpHeight := 48.0

const OPEN_CHEST = 2
#
#var jumpPath = []
#var currentPoint = 0
var startPos : Vector2
var endPos : Vector2


func _add_states() -> void:
	states.append("open_chest_state")
	
	yield(TempTimer.idle_frame(self), "timeout")
	chest.connect("open", self, "open_chest")


func open_chest_state(delta: float) -> void:
	var diff := startPos - endPos
	
	var timeLeft = openChestJumpTimer.time_left
	var totalTime = openChestJumpTimer.wait_time
	
	var percentage = (timeLeft / totalTime)
	diff *= percentage
	diff.y -= sin(PI * percentage) * jumpHeight
	
	global_position = endPos + diff
	
	if global_position.distance_to(endPos) < 1:
		state = WALK


func open_chest() -> void:
	startPos = global_position
	endPos = chest.global_position - Vector2(0, 29)
	
	openChestJumpTimer.start()
	state = OPEN_CHEST
