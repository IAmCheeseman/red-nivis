extends Node2D

onready var camera = $Camera2D
onready var anim = $AnimationPlayer

export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var jumpPrompt = get_node(jumpPrompt) as Sprite
export(NodePath) onready var walkPrompt = get_node(walkPrompt) as Node2D

func _ready() -> void:
	player.hide()
	player.lockMovement = true
	player.global_position = global_position
	
	jumpPrompt.show()
	walkPrompt.hide()
	
	player.get_node("Camera").current = false
	anim.play("Intro")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and visible and !anim.is_playing():
		player.show()
		player.lockMovement = false
		player.jump()
		
		GameManager.emit_signal("screenshake", 10, 2, .025, .1)
		
		hide()
		
		jumpPrompt.hide()
		walkPrompt.show()
		
		var playerCam: Camera2D = player.get_node("Camera")
		
		playerCam.global_position = global_position
		playerCam.smoothing_enabled = true
		
		playerCam.current = true
		camera.current = false
