extends KinematicBody2D

onready var anim := $AnimationPlayer
onready var sprite = $ScaleHelper/Sprite

onready var dialog = $Dialog/Dialog
onready var interactionZone = $Iteraction

onready var floorRay = $FloorRay

onready var startingPos = global_position.x

onready var wanderTimer = $WanderTimer

const PLAYER = preload("res://Entities/Player/Player.tres")

var vel:Vector2 = Vector2.ZERO
var targetX: float

export var defaultDialog := "Introduction"
export var wanderRange := 0
export var accel := 24.0
export var speed := 120.0
export var wanderTime := Vector2(5.0, 15.0)
export var removeBarsOnDialogEnd := true
export var shove := -24
export var idleAnim := "Default"

signal start_talking
signal dialog_finished

const WALK = 0
const TALK = 1

var state = WALK

const states = [
	"walk_state",
	"talk_state"
]

var playerStartPos: Vector2
var playerEndPos: Vector2


func _ready() -> void:
	dialog.hide()
	targetX = global_position.x
	_add_states()


func _add_states() -> void:
	pass


func _process(delta):
	call(states[state], delta)
	
	vel.y += Globals.GRAVITY * delta
	vel.y = move_and_slide(vel).y


func walk_state(delta: float) -> void:
	if !floorRay.is_colliding(): return
	var targetPos = Vector2(targetX, global_position.y)
	var dir := global_position.direction_to(targetPos).x
	
	vel.x = lerp(vel.x, dir * speed, accel * delta)
	
	sprite.rotation_degrees = vel.x / 25
	sprite.scale.x = -1 if vel.x < 0 else 1
	
	if global_position.distance_to(targetPos) < 5:
		if anim.has_animation(idleAnim): anim.play(idleAnim)
		sprite.rotation = 0
		vel.x = 0
	elif anim.has_animation("Walk"):
		anim.play("Walk")


func talk_state(delta: float) -> void:
	vel.x = lerp(vel.x, 0, accel * delta)
	
	sprite.rotation_degrees = vel.x / 25
	
	if anim.has_animation(idleAnim): anim.play(idleAnim)


func _on_interaction() -> void:
	emit_signal("start_talking")
	start_dialog(defaultDialog)


func start_dialog(lines:String) -> void:
	dialog.show()
	dialog.start_dialog(lines)
	interactionZone.disabled = true
	
	PLAYER.playerObject.lockMovement = true
	
	GameManager.emit_signal("zoom_in", 1, -1, .2, global_position)
	GameManager.currentCamera.removeBars = removeBarsOnDialogEnd
	
	state = TALK
	
	PLAYER.playerObject.global_position = global_position + Vector2(shove, -2)
	PLAYER.playerObject.sprite.scale.x = -float(shove) / shove


func _on_dialog_finished() -> void:
	interactionZone.disabled = false
	state = WALK
	
	GameManager.emit_signal("zoom_in", .9, -1, .2, global_position)
	PLAYER.playerObject.lockMovement = false
	
	emit_signal("dialog_finished")


func get_target_pos() -> void:
	randomize()
	targetX = startingPos + rand_range(
		-wanderRange,
		 wanderRange
	)
	wanderTimer.start(rand_range(wanderTime.x, wanderTime.y))


