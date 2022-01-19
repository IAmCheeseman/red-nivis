extends Node2D

onready var sprite = $Sprite

export var upgrade:Resource = preload("res://Items/Upgrades/Teleport/Teleport.tres")

var player = preload("res://Entities/Player/Player.tres")


func _ready():
	sprite.texture = upgrade.icon


func _on_interaction():
	player.upgrades.append(upgrade.abilityScript)
	player.playerObject.get_node("Abilities").add_abilities()
	queue_free()
