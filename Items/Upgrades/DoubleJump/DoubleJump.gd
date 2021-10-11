extends Node

var player:Node2D

var hasJumped = false


func _process(_delta: float) -> void:
	if !player: return
	if player.is_grounded() or player.state == player.states.WALLSLIDE: hasJumped = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump")\
	and !player.is_grounded()\
	and !hasJumped\
	and player.state != player.states.WALLSLIDE:
		hasJumped = true
		player.jump()
		player.animationPlayer.play("DoubleJump")

