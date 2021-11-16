extends Node

var player:Node2D

var hasJumped = false


func _process(_delta: float) -> void:
	if !player: return
	
	var isNotJumping = player.vel.y > 0
	if player.is_on_floor()\
	or player.state == player.states.WALLSLIDE\
	and isNotJumping:
		hasJumped = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump")\
	and !player.is_grounded()\
	and !hasJumped\
	and player.state != player.states.WALLSLIDE:
		hasJumped = true
		player.jump()
		player.animationPlayer.play("DoubleJump")

