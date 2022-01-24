extends Node

const HOOKSHOT = preload("res://Items/Upgrades/Hookshot/Hookshot.tscn")

var currentHookshot: Node2D

var player: Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hookshot"):
		if is_instance_valid(currentHookshot): return
		var newHookshot = HOOKSHOT.instance()
		newHookshot.global_position = player.global_position
		GameManager.add_child(newHookshot)
		currentHookshot = newHookshot
