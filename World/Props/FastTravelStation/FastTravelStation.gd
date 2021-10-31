extends Node2D

onready var fastTravelMenu = $CanvasLayer/FastTravelMenu


func _ready() -> void:
	if !GameManager.worldData.position\
		in FastTravel.discoveredStations:
		FastTravel.discoveredStations.append(GameManager.worldData.position)

func _on_interaction() -> void:
	fastTravelMenu.show()
	GameManager.inGUI = true
