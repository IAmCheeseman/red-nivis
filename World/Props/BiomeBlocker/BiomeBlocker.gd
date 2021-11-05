extends Node2D


onready var anim = $AnimationPlayer


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
	anim.play("Deny")
	
	emit_signal("removeLeft")
	emit_signal("removeRight")
	emit_signal("removeUp")
	emit_signal("removeDown")

