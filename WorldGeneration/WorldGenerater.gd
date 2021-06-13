extends Node
class_name WorldGenerator

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
	var southColor = Color("#b14926")
	var eastColor = Color("#490a15")
	var westColor = Color("#174646")

	var prefabSize = 16
	var prefabCount = 22

	var roomOutlines = "res://WorldGeneration/RoomOutlines/RO%s.png"
	var prefabs = "res://WorldGeneration/Prefabs/prefab%s.png"

	# Getting an image to be used as a general layout
	var roomOutline:Image = load(
		roomOutlines % round(rand_range(1, 10))
		).get_data()

	# Creating the image used to hold the specific details of the room
	var roomLayout = Image.new()
	roomLayout.create(
	(roomOutline.get_width()*prefabSize)+1, (roomOutline.get_height()*prefabSize)+1,
	false, Image.FORMAT_RGBAH
	)

	roomLayout.fill(solidColor)

	roomOutline.lock()
	roomLayout.lock()

	var connectionMap = []

	# Creating a connection map
	for x in roomOutline.get_width():
		connectionMap.append([])
		for y in roomOutline.get_height():
			var roomConnections = {
# warning-ignore:narrowing_conversion
				"north" : !roomOutline.get_pixel(x, clamp(y-1, 0, INF)).is_equal_approx(solidColor),
# warning-ignore:narrowing_conversion
				"south" : !roomOutline.get_pixel(x, clamp(y+1, -INF, roomOutline.get_height()-1) ).is_equal_approx(solidColor),
# warning-ignore:narrowing_conversion
				"west" : !roomOutline.get_pixel(clamp(x-1, 0, INF), y).is_equal_approx(solidColor),
# warning-ignore:narrowing_conversion
				"east" : !roomOutline.get_pixel(clamp(x+1, -INF, roomOutline.get_width()-1), y).is_equal_approx(solidColor)
			}

			connectionMap[x].append(roomConnections)

	# Creating the room layout
	for x in roomOutline.get_width():
		for y in roomOutline.get_height():

			# Getting the prefab section color
			var rLayoutP = roomOutline.get_pixel(x, y)

			if !rLayoutP.is_equal_approx(solidColor):
				# Otherwise, select a prefab to use
				var prefab:Image = load(prefabs % round(rand_range(1, prefabCount))).get_data()
				prefab.lock()

				for xx in prefab.get_width():
					for yy in prefab.get_height():
						# Creating the prefab in the room

						var tileColor = prefab.get_pixel(xx, yy)

						# Checking for a solid
						if tileColor.is_equal_approx(solidColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), solidColor)

						# Checking for ground
						if tileColor.is_equal_approx(emptyColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)

						# Checking the directions
						if tileColor.is_equal_approx(northColor) and connectionMap[x][y].north: # NORTH
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)
						if tileColor.is_equal_approx(southColor) and connectionMap[x][y].south: # SOUTH
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)
						if tileColor.is_equal_approx(eastColor) and connectionMap[x][y].east: # EAST
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)
						if tileColor.is_equal_approx(westColor) and connectionMap[x][y].west: # WEST
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)


						# Checking for an enemy
						if tileColor.is_equal_approx(enemyColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), enemyColor)


	var ca = CellularAutomata.new()
	roomLayout = ca.iterate(roomLayout, 1, 3, 5, solidColor)
	ca.queue_free()


	var texture = ImageTexture.new()
	texture.create_from_image(roomLayout)
	get_parent().get_node("CanvasLayer/TextureRect").texture = texture
	get_parent().get_node("CanvasLayer/TextureRect").rect_position -= Vector2(texture.get_width(), texture.get_height())/2
	roomLayout.save_png("user://output.png")


func _input(event):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()


