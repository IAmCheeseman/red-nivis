extends Node2D


onready var anim = $AnimationPlayer

export var requiredUpgrade:Resource

var playerData = preload("res://Entities/Player/Player.tres")


signal removeUp()
signal removeDown()
signal removeRight()
signal removeLeft()


func _ready() -> void:
	var worldData = GameManager.worldData
	var pos = worldData.position
	var biome = worldData.rooms[pos.x][pos.y].biome
	var goodThings = [biome, null]
	
	if worldData.rooms[pos.x-1][pos.y].biome in goodThings:
		emit_signal("removeLeft")
	if worldData.rooms[pos.x+1][pos.y].biome in goodThings:
		emit_signal("removeRight")
	if worldData.rooms[pos.x][pos.y-1].biome in goodThings:
		emit_signal("removeUp")
	if worldData.rooms[pos.x][pos.y+1].biome in goodThings:
		emit_signal("removeDown")


func _on_Iteraction_interaction() -> void:
	if requiredUpgrade.abilityScript in playerData.upgrades:
		anim.play("Accept")
		emit_signal("removeLeft")
		emit_signal("removeRight")
		emit_signal("removeUp")
		emit_signal("removeDown")
		return
	anim.play("Deny")

