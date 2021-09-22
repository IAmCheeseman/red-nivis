extends KinematicBody2D

onready var sprite = $ScaleHelper/Sprite

onready var playerDetection = $PlayerDetection

onready var dialog = $Dialog
onready var dialogAnim = $Dialog/AnimationPlayer


var vel:Vector2 = Vector2.ZERO
var playedDialog = false


func _process(delta):
	vel.y += GameManager.gravity*delta
	vel.y = move_and_slide(vel).y
	if playerDetection.get_player() and !playedDialog:
		playedDialog = true
		dialogAnim.play("Appear")
	elif playedDialog and !playerDetection.get_player():
		playedDialog = false
