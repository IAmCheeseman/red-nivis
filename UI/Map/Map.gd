extends ViewportContainer


onready var tiles:TileMap = $Viewport/MapTiles
onready var camera:Camera2D = $Viewport/Camera

var mapData = preload("res://World/WorldManagement/WorldData.tres")


func _ready() -> void:
	for x in mapData.rooms.size():
		for y in mapData.rooms[0].size():
			if mapData.rooms[x][y].biome: tiles.set_cell(x, y, 0)
	camera.position = mapData.position*tiles.cell_size+tiles.cell_size*.5
