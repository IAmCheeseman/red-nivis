extends Control

onready var mapGenerator = $MapGenerator
onready var selection = $MapTiles/Selection
onready var mapTiles = $MapTiles

var mapData = GameManager.worldData

var mouseMovedLast = false

signal room_selected()


func _ready() -> void:
	mapGenerator.generate_map()


func _process(delta: float) -> void:
	selection.position = mapTiles.world_to_map(mapTiles.get_local_mouse_position())*mapTiles.cell_size
	selection.position += mapTiles.cell_size/2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion\
	and Input.is_action_pressed("use_item"):
		mapTiles.position += event.relative
		mouseMovedLast = true
		return
	
	if Input.is_action_just_released("use_item") and\
	!mouseMovedLast and visible:
		var rpos = mapTiles.world_to_map(selection.position)
		if rpos in FastTravel.discoveredStations:
			mapData.position = rpos
			emit_signal("room_selected")
	else:
		mouseMovedLast = false
