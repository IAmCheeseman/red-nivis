extends Node2D

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

var player: Node2D
var gnome: Node2D


func _process(_delta: float) -> void:
	if !player: return
	
	look_at(player.global_position - Vector2(0, 8))


func shoot() -> void:
	if gnome.state == gnome.DEAD: return
	
	var newStick = preload("res://Entities/Enemies/Bosses/Gnome/Stick.tscn").instance()
	var dir = global_position.direction_to(player.global_position - Vector2(0, 8))
	
	newStick.global_position = global_position + (dir * 16)
	newStick.direction = dir
	newStick.speed = 240
	
	GameManager.spawnManager.spawn_object(newStick)
	
	gnome.sticks.append(newStick)


func test(g: Node2D) -> bool:
	gnome = g
	if gnome.state in [gnome.ASCEND]: return false
	anim.play("WhipOut")
	return true
