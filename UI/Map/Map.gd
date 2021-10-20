extends ViewportContainer


onready var tiles:TileMap = $Viewport/MapTiles
onready var camera:Camera2D = $Viewport/Camera

var mapData = preload("res://World/WorldManagement/WorldData.tres")


func _ready() -> void:
	for x in mapData.rooms.size():
		for y in mapData.rooms[0].size():
			var biome = mapData.rooms[x][y].biome
			var roomIcon = mapData.rooms[x][y].roomIcon
			if biome:
				tiles.set_cell(x, y, 0)
				if roomIcon:
					var sprite = Sprite.new()
					sprite.texture = roomIcon
					sprite.position = Vector2(x, y)*tiles.cell_size
					tiles.add_child(sprite)
	camera.position = mapData.position*tiles.cell_size+tiles.cell_size*.5
