extends "res://Entities/NPC/NPC.gd"

onready var openChestJumpTimer = $OpenChestJump
onready var openChestTimer = $OpenChest

export(NodePath) onready var chest = get_node(chest)
export var jumpHeight := 48.0

const JUMP_CHEST = 2
const OPEN_CHEST = 3


var startPos : Vector2
var endPos : Vector2


func _add_states() -> void:
	states.append("jump_to_chest_state")
	states.append("open_chest_state")
	
	yield(TempTimer.idle_frame(self), "timeout")
	chest.connect("open", self, "open_chest")


func jump_to_chest_state(_delta: float) -> void:
	var diff := startPos - endPos
	
	var timeLeft = openChestJumpTimer.time_left
	var totalTime = openChestJumpTimer.wait_time
	
	var percentage = (timeLeft / totalTime)
	diff *= percentage
	diff.y -= sin(PI * percentage) * jumpHeight
	
	global_position = endPos + diff
	
	anim.play("Jump")
	
	if global_position.distance_to(endPos) < 1:
		vel.y = 0
		state = OPEN_CHEST
		openChestTimer.start()
		sprite.scale = Vector2.ONE


func open_chest_state(delta: float) -> void:
	vel = Vector2(0, -Globals.GRAVITY * delta)
	global_position = chest.standPos.global_position
	
	chest.anim.play("Drill")


func open_chest() -> void:
	if state == JUMP_CHEST: return
	
	startPos = global_position
	endPos = chest.standPos.global_position
	
	removeBarsOnDialogEnd = false
	start_dialog("ChestOpen")
	
	yield(self, "dialog_finished")
	removeBarsOnDialogEnd = true
	
	GameManager.emit_signal("zoom_in", .6, 3, .2, endPos)
	
	openChestJumpTimer.start()
	state = JUMP_CHEST
	
	yield(TempTimer.timer(self, .75), "timeout")
	GameManager.emit_signal("screenshake", 5, 1, .015, openChestTimer.wait_time)

func _on_open_chest_timeout() -> void:
	state = WALK
	targetX = startingPos
	
	chest.anim.play("Open")
	
	GameManager.emit_signal("screenshake", 6, 5, .015, 0.2)
	yield(TempTimer.timer(self, .1), "timeout")
	GameManager.frameFreezer.freeze_frames(.3)
	
	defaultDialog = "AfterOpen"
