extends Node2D

onready var upgradeSelection = $CanvasLayer/UpgradeSelection
var playerData = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	if playerData.unlockedUpgrades.size() == 0: queue_free()


func _on_interaction() -> void:
	GameManager.inGUI = true
	upgradeSelection.show()


