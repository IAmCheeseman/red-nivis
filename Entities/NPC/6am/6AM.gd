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


func jump_to_chest_state(delta: float) -> void:
	var diff := startPos - endPos
	
	var timeLeft = openChestJumpTimer.time_left
	var totalTime = openChestJumpTimer.wait_time
	
	var percentage = (timeLeft / totalTime)
	diff *= percentage
	diff.y -= sin(PI * percentage) * jumpHeight
	
	global_position = endPos + diff
	
	anim.play("Jump")
	
#	if percentage < 0.5:
#		sprite.scale.x = 1 - abs(percentage - .5)
#		sprite.scale.y = 1 + (1 - sprite.scale.x)
	
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
	
	openChestJumpTimer.start()
	state = JUMP_CHEST


func _on_open_chest_timeout() -> void:
	state = WALK
	targetX = startingPos
	
	chest.anim.play("Open")
