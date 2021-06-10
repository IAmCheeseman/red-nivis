extends Node

onready var tilemap : TileMap = get_parent().get_node("TileMap")

var rooms = preload("res://WorldGeneration/Rooms.tscn").instance().get_children()
var wmaxSteps = 100
var wviableArea = Rect2(Vector2.ZERO, Vector2.ONE*1000)
var wturnChance = 75


func _ready():
	randomize()
	generate_room()

# _init(_maxSteps, _viableArea, _amountOfWalkers, _directionChance)
func generate_room():
	var walker = DrunkWalker.new(wmaxSteps, wviableArea, 1, wturnChance)
	var wOutput = walker.walk()

	var roomPlacementChance = .75
	var roomOverChance = .20
	var roomRects = []

	for step in wOutput:

		# Checking if it'd place in another room

		# Creating the room
		if rand_range(0, 1) <= roomPlacementChance:
			if rooms.size() == 0:
				break

			# Selecting a room
			rooms.shuffle()
			var room: TileMap = rooms.pop_front()
			var tiles = room.get_used_cells()

			# Making sure it's not placed in another room
			var roomRect = room.get_used_rect()
			roomRect.position = step
			var stop = false
			for rect in roomRects:
				if rect.intersects(roomRect):
					stop = true
					break
			if stop:
				rooms.append(room)
				continue

			roomRects.append(roomRect)

			# Setting the tiles
			for tile in tiles:
				if !step+tile in wOutput:
					tilemap.set_cellv(step+tile, 0)
					tilemap.update_bitmask_area(step+tile)



# Gets surrounding tiles
func get_neighbors(tilePos : Vector2, tileset : TileMap, getCorners = false) -> Array:
	var xx = -1
	var yy = -1

	var CORNERTILES = [
		Vector2(1, 1),
		Vector2(1, -1),
		Vector2(-1, 1),
		Vector2(-1, -1)
	]

	var neighboringTiles = []

	for tile in range(9):
		if tile == 5:
			continue

		if getCorners:
			neighboringTiles.append(tileset.get_cell(tilePos.x+xx, tilePos.y+yy))
		elif !Vector2(xx, yy) in CORNERTILES:
			neighboringTiles.append(tileset.get_cell(tilePos.x+xx, tilePos.y+yy))

		xx += 1
		xx = wrapi(xx, -1, 2)
		if xx == -1:
			yy += 1
	return neighboringTiles
