extends Node

onready var tilemap : TileMap = get_parent().get_node("TileMap")

var rooms = preload("res://WorldGeneration/Rooms.tscn").instance().get_children()
var minPrefabs = 2
var maxPrefabs = 4


func _ready():
	randomize()
	generate_room()

# _init(_maxSteps, _viableArea, _amountOfWalkers, _directionChance)
func generate_room():
	var roomCount = rand_range(minPrefabs, maxPrefabs)
	var nextRoomDir = Vector2.RIGHT
	var roomSize = Vector2.ONE
	var lastRoomPos = nextRoomDir*roomSize

	randomize()

	for nr in roomCount:
		rooms.shuffle()
		var room:TileMap = rooms.pop_front()
		var roomPos = (nextRoomDir*roomSize)+lastRoomPos
		var cells = room.get_used_cells()

		for cell in cells:
			if room.get_cellv(cell) == 0:
				tilemap.set_cellv(cell+roomPos, 0)
				tilemap.update_bitmask_area(cell+roomPos)

		var dirs = [
			Vector2.RIGHT,
			Vector2.DOWN,
			Vector2.UP,
			Vector2.LEFT
		]
		dirs.shuffle()

		lastRoomPos = roomPos
		roomSize = room.get_used_rect().end
		nextRoomDir = dirs.pop_front()

		tilemap.set_cellv(Vector2(roomSize.x, roomSize.y+1), -1)

