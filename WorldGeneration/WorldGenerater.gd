extends Node

onready var tilemap : TileMap = get_parent().get_node("TileMap")

var rooms = preload("res://WorldGeneration/Rooms.tscn").instance().get_children()
var minPrefabs = 2
var maxPrefabs = 4


func _ready():
	randomize()
	generate_room()


func generate_room():
	randomize()

	# Colors telling the algorithim what to place in certain spots
	var enemyColor = Color(0.627451, 0.047059, 0.047059)
	var emptyColor = Color(1, 1, 1)
	var solidColor = Color(0, 0, 0)

	var prefabSize = 10

	var roomOutlines = "res://WorldGeneration/RoomOutlines/RO%s.png"
	var prefabs = "res://WorldGeneration/Prefabs/prefab%s.png"

	# Getting an image to be used as a general layout
	var roomOutline:Image = load(
		roomOutlines % round(rand_range(1, 3))
		).get_data()

	# Creating the image used to hold the specific details of the room
	var roomLayout = Image.new()
	roomLayout.create(
	roomOutline.get_width()*prefabSize, roomOutline.get_height()*prefabSize,
	false, Image.FORMAT_RGBAH
	)

	roomOutline.lock()

	for x in roomOutline.get_width():
		for y in roomOutline.get_height():
			var rLayoutP = roomOutline.get_pixel(x, y)

			# Checking if the tile is completely solid
			if rLayoutP.is_equal_approx(solidColor):
				for xx in 10*x:
					for yy in 10*y:
						roomLayout.set_pixel(xx, yy, solidColor)
				continue
			else:
				# Otherwise, select a prefab to use
				var prefab:Image = load(prefabs % round(rand_range(1, 5))).get_data()
				prefab.lock()

				for xx in prefab.get_width():
					for yy in prefab.get_height():
						pass







