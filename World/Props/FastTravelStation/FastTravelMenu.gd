extends Control

onready var buttonContainer = $CenterContainer/HBoxContainer/ScrollContainer/VBoxContainer

 dfunc _ready() -> void:
	yield(get_tree(), "idle_frame")
	for i in FastTravel.discoveredStations:
		var newPoint = Button.new()
		var room = GameManager.worldData.rooms[i.x][i.y]
		newPoint.text = "%s, %s" % [i, room.biome.name]
		newPoint.set_meta("location", i)
		newPoint.connect("pressed", self, "_on_fast_travel_pressed", [newPoint])
		buttonContainer.add_child(newPoint)


func _on_fast_travel_pressed(button:Button):
	GameManager.worldData.position = button.get_meta("location")
	GameManager.inGUI = false
	get_tree().reload_current_scene()


func _on_Button_pressed() -> void:
	hide()
	GameManager.inGUI = false
