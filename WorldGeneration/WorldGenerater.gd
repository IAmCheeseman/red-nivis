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
	var enemyColor = Color("#a00c0c")
	var emptyColor = Color("#ffffff")
	var solidColor = Color("#000000")

	# Directional colors
	var northColor = Color("#221f3e")
	var southColor = Color("#174646")
	var eastColor = Color("#490a15")
	var westColor = Color("#b14926")

	var prefabSize = 15

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
	roomLayout.lock()

	# Creating the room layout
	for x in roomOutline.get_width()-1:
		for y in roomOutline.get_height()-1:

			# Getting the general tile thing
			var rLayoutP = roomOutline.get_pixel(x, y)

			# Checking if the tile is completely solid
			if rLayoutP.is_equal_approx(solidColor):
				for xx in prefabSize*x:
					for yy in prefabSize*y:
						roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), solidColor)

			else:
				# Otherwise, select a prefab to use
				var prefab:Image = load(prefabs % round(rand_range(1, 5))).get_data()
				prefab.lock()

				for xx in prefab.get_width()-1:
					for yy in prefab.get_height()-1:
						# Creating the prefab in the room

						var tileColor = prefab.get_pixel(xx, yy)

						# Checking for a solid
						if tileColor.is_equal_approx(solidColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), solidColor)

						# Checking for ground
						if tileColor.is_equal_approx(emptyColor)\
						or tileColor.is_equal_approx(northColor)\
						or tileColor.is_equal_approx(southColor)\
						or tileColor.is_equal_approx(eastColor)\
						or tileColor.is_equal_approx(westColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)

						# Checking for an enemy
						if tileColor.is_equal_approx(enemyColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), enemyColor)

	var streamTex = ImageTexture.new()
	streamTex.create_from_image(roomLayout)
	get_parent().get_node("CanvasLayer/TextureRect").texture = streamTex






