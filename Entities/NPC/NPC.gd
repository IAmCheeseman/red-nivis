extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var sprite = $ScaleHelper/Sprite

onready var dialog = $Dialog/Dialog
onready var interactionZone = $Iteraction

onready var startingPos = global_position.x

onready var wanderTimer = $WanderTimer

var vel:Vector2 = Vector2.ZERO
var targetX: float

export var defaultDialog := "Introduction"
export var wanderRange := 0
export var accel := 24.0
export var speed := 120.0
export var wanderTime := Vector2(5.0, 15.0)

signal dialog_finished


func _ready() -> void:
	dialog.hide()
	get_target_pos()


func _process(delta):
	var dir := global_position.direction_to(Vector2(targetX, global_position.y)).x
	
	vel.x = lerp(vel.x, dir * speed, accel * delta)
	
	if is_zero_approx(vel.x):
		anim.play("Default")
	elif anim.has_animation("Walk"):
		anim.play("Walk")
	
	sprite.rotation_degrees = vel.x / 25
	sprite.scale.x = -1 if vel.x < 0 else 1
	
	if global_position.distance_to(Vector2(targetX, global_position.y)) < 5:
		vel.x = 0
	
	vel.y += Globals.GRAVITY * delta
	vel.y = move_and_slide(vel).y


func _on_interaction() -> void:
	start_dialog(defaultDialog)


func start_dialog(lines:String) -> void:
	dialog.show()
	dialog.start_dialog(lines)
	interactionZone.disabled = true


func _on_dialog_finished() -> void:
	interactionZone.disabled = false
	emit_signal("dialog_finished")


func get_target_pos() -> void:
	targetX = startingPos + rand_range(
		-wanderRange,
		 wanderRange
	)
	wanderTimer.start(rand_range(wanderTime.x, wanderTime.y))
