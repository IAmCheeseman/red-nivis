extends Node

var player:Node2D

var hasJumped = false


func _process(_delta: float) -> void:
	if !player: return
	if player.is_grounded(): hasJumped = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump")\
	and !player.is_grounded()\
	and !hasJumped:
		hasJumped = true
		player.jump()

