extends Node2D

onready var fastTravelMenu = $CanvasLayer/TeleportMenu
onready var teleportEffect = $Teleport/AnimationPlayer

onready var playerData = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	# Adding the station to a list of stations if 
	# it's not already added.
	if !GameManager.worldData.position\
		in FastTravel.discoveredStations:
		FastTravel.discoveredStations.append(GameManager.worldData.position)


# Showing the teleportation gooey
func _on_interaction() -> void:
	fastTravelMenu.show()
	GameManager.inGUI = true


# Gets called when the teleportation animation is done
func teleport() -> void:
	GameManager.inGUI = false
	var _discard = get_tree().reload_current_scene()


# Locking the player in place and playing teleportation
# animation when a location is selected
func _on_room_selected() -> void:
	playerData.playerObject.hide()
	playerData.playerObject.lockMovement = true
	teleportEffect.get_parent().global_position.x\
	= playerData.playerObject.global_position.x
	GameManager.worldData.playerPos = playerData.playerObject.global_position
	teleportEffect.play("Teleport")
	fastTravelMenu.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fastTravelMenu.hide()
		GameManager.inGUI = false
