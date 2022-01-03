extends Node2D

onready var upgradeSelection = $CanvasLayer/UpgradeSelection


func _on_interaction() -> void:
	GameManager.inGUI = true
	upgradeSelection.show()


