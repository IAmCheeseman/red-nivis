extends Node2D

onready var fastTravelMenu = $CanvasLayer/FastTravelMenu
onready var teleportEffect = $Teleport/AnimationPlayer

onready var playerData = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	if !GameManager.worldData.position\
		in FastTravel.discoveredStations:
		FastTravel.discoveredStations.append(GameManager.worldData.position)

func _on_interaction() -> void:
	fastTravelMenu.show()
	GameManager.inGUI = true


func teleport():
	get_tree().reload_current_scene()


func _on_FastTravelMenu_placeSelected() -> void:
	playerData.playerObject.hide()
	playerData.playerObject.lockMovement = true
	teleportEffect.get_parent().global_position.x\
	= playerData.playerObject.global_position.x
	teleportEffect.play("Teleport")
