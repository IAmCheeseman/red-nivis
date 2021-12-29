extends Control

onready var mapGenerator = $MapGenerator
onready var selection = $MapTiles/Selection
onready var mapTiles = $MapTiles





func _process(delta: float) -> void:
	selection.position = mapTiles.get_local_mouse_position().snapped(Vector2.ONE*mapTiles.cell_size)-Vector2.ONE

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion\
	and Input.is_action_pressed("use_item"):
		mapTiles.position -= event.relative
		return
