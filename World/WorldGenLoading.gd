extends Control

onready var progress = $CenterContainer/VBox/ProgressBar

var worldData = preload("res://World/WorldManagement/WorldData.tres")


func _ready() -> void:
	randomize()
	worldData.connect("update_percent", self, "update_progress")
	worldData.generate_world()
	AudioServer.set_bus_effect_enabled(4, 0, true)
	AudioServer.set_bus_effect_enabled(5, 0, true)
	get_tree().change_scene("res://World/WorldManagement/World.tscn")


func update_progress(amt: float) -> void:
	progress.value = amt


func _process(delta: float) -> void:
	pass
	#get_tree().change_scene("res://World/WorldManagement/World.tscn")
