extends Node2D


export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var jumpPrompt = get_node(jumpPrompt) as Sprite
export(NodePath) onready var walkPrompt = get_node(walkPrompt) as Node2D

func _ready() -> void:
	player.hide()
	player.lockMovement = true
	player.global_position = global_position
	
	jumpPrompt.show()
	walkPrompt.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and visible:
		player.show()
		player.lockMovement = false
		player.jump()
		
		GameManager.emit_signal("screenshake", 10, 2, .025, .1)
		
		hide()
		
		jumpPrompt.hide()
		walkPrompt.show()
