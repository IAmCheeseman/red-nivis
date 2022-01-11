extends Node


const BOMB = preload("res://Items/Upgrades/Grenade/Grenade.tscn")

var baseThrowStrength := 1

var cooldown: Timer
var player: Node2D


func _ready() -> void:
	cooldown = Timer.new()
	cooldown.one_shot = true
	cooldown.wait_time = .15
	add_child(cooldown)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grenade") and cooldown.is_stopped():
		var newBomb = BOMB.instance()
		newBomb.global_position = player.global_position - Vector2(0, 8)
		var mousePos = player.get_local_mouse_position()
		var throwStrength:float = mousePos.length() * 3
		newBomb.apply_central_impulse(
			mousePos.normalized() * throwStrength
		)
		GameManager.add_child(newBomb)
		cooldown.start()
