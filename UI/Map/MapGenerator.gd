extends Node

export var tilesPath: NodePath
onready var tiles := get_node(tilesPath)

var mapData = GameManager.worldData


func generate_map() -> void:
	for x in mapData.rooms.size():
		for y in mapData.rooms[0].size():
			var biome = mapData.get_biome_by_index(mapData.rooms[x][y].biome)
			var roomIcon = mapData.rooms[x][y].roomIcon
			if biome:
				if (mapData.rooms[x][y].nearDiscovered or GameManager.revealMap) and !mapData.rooms[x][y].secret:
					tiles.set_cell(x, y, 0)
				if mapData.rooms[x][y].discovered or GameManager.revealMap:
					tiles.set_cell(x, y, biome.biomeTile + 1)
					_set_icon(roomIcon, x, y)


func _set_icon(roomIcon, x, y):
	if roomIcon:
		var sprite = Sprite.new()
		sprite.texture = roomIcon
		sprite.centered = false
		sprite.position = Vector2(x, y)*tiles.cell_size
		tiles.add_child(sprite)
