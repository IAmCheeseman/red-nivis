extends Area2D

const PLAYER = preload("res://Entities/Player/Player.tres")


onready var label:Label = $Label


export var ignoreDistance := false
export var disabled := false setget set_disabled

var playerNear = false

signal interaction
signal player_close
signal player_left


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		# Checking if it's the player and
		# Emitting a signal if it's the player
		if playerNear and is_closest() and !disabled:
			emit_signal("interaction")


# Updating player status and emitting signals
# based on player position
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		playerNear = true
		# Setting the label to show correct key
		label.text = "<%s>" % OS.get_scancode_string(
			InputMap.get_action_list("interact")[0].scancode
		)
		if !disabled:
			label.show()
			emit_signal("player_close")

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		playerNear = false
		if !disabled:
			label.hide()
			emit_signal("player_left")


# Checks if the player is closest to this interactable.
# Bad code, but it works since there's
# not going to be a huge number of 
# interactables in the scene at a time
func is_closest() -> bool:
	var dist = global_position.distance_to(
		PLAYER.playerObject.global_position)
	for i in get_tree().get_nodes_in_group("interactable"):
		if i.global_position.distance_to(
			PLAYER.playerObject.global_position) < dist:
			return false
	return true


func set_disabled(val:bool):
	disabled = val 
	if disabled: label.hide()

