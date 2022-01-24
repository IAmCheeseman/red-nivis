extends Node

const HOOKSHOT = preload("res://Items/Upgrades/Hookshot/Hookshot.tscn")

var currentHookshot: Node2D

var player: Node2D
var cooldown: Timer

func _ready() -> void:
	cooldown = Timer.new()
	cooldown.one_shot = true
	cooldown.wait_time = 1.5
	add_child(cooldown)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hookshot") and cooldown.is_stopped():
		if is_instance_valid(currentHookshot): return
		var newHookshot = HOOKSHOT.instance()
		newHookshot.global_position = player.global_position
		newHookshot.player = player
		GameManager.add_child(newHookshot)
		currentHookshot = newHookshot
		cooldown.start()
