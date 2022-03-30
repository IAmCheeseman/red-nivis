extends Node

var player:Node2D

var hasJumped = false
var hitbox: Area2D


func _ready() -> void:
	hitbox = preload("res://Items/Upgrades/DoubleJump/BootHitbox.tscn").instance()
	hitbox.connect("hit_object", self, "bounce")
	hitbox.damage = 30
	add_child(hitbox)


func bounce(_a=null) -> void:
	if !player: return
	player.vel.y = -150


func _process(_delta: float) -> void:
	if !player: return
	if hitbox: hitbox.position = player.position

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
		player.vel.y *= .9
		for i in player.djParticles.get_children():
			i.rotation = player.vel.angle()+deg2rad(90)
		player.animationPlayer.play("DoubleJump")

