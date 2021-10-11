extends Node

var player:Node2D

onready var wallCheckers = player.get_node("TileCheckers")
var slideTimer = Timer.new()

func _ready() -> void:
	add_child(slideTimer)
	slideTimer.one_shot = true
	slideTimer.wait_time = .2


func _physics_process(_delta: float) -> void:
	var isSliding = check_for_wall_slide() and !player.is_grounded()
	
	if isSliding and slideTimer.is_stopped():
		player.state = player.states.WALLSLIDE
	elif player.state != player.states.DEAD:
		player.state = player.states.WALK


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.state == player.states.WALLSLIDE:
		player.vel.x = -wallCheckers.get_child(0).cast_to.normalized().x*200
		
		slideTimer.start()


func check_for_wall_slide():
	var allIsOkay = true
	for i in wallCheckers.get_children():
		i.cast_to.x = 6 if player.vel.normalized().x > 0 else -6
		i.force_raycast_update()
		if !i.is_colliding(): allIsOkay = false
	return allIsOkay

