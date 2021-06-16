extends Node
class_name WorldGenerator


var minPrefabs = 2
var maxPrefabs = 4


enum {NORTH, SOUTH, EAST, WEST, NONE}


# Colors telling the algorithim what to place in certain spots
var enemyColor = Color("#a00c0c")
var emptyColor = Color("#ffffff")
var solidColor = Color("#000000")
var ruinColor = Color("#44cb30")

# Directional colors
var northColor = Color("#221f3e")
var southColor = Color("#b14926")
var eastColor  = Color("#490a15")
var westColor  = Color("#174646")

func generate_room(planet:Planet):
	randomize()

	var prefabSize = 16
	var prefabCount = 48
	var outlineCount = 20
	var viablePrefabs = []
	for i in prefabCount:
		viablePrefabs.append(50)

	var roomOutlines = "res://WorldGeneration/RoomOutlines/RO%s.png"
	var prefabs = planet.prefabs+"prefab%s.png"

	# Getting an image to be used as a general layout
	var roomOutline:Image = load(
		roomOutlines % round(rand_range(1, outlineCount))
		).get_data()

	# Creating the image used to hold the specific details of the room
	var roomLayout = Image.new()
	roomLayout.create(
	(roomOutline.get_width()*prefabSize), (roomOutline.get_height()*prefabSize),
	false, Image.FORMAT_RGBAH
	)

	var roomRect = Rect2(0, 0, roomOutline.get_width(), roomOutline.get_height())

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
				"north" : !roomOutline.get_pixel(x, clamp(y-1, 0, INF)).is_equal_approx(solidColor) and roomRect.has_point(Vector2(x, y-1)),
# warning-ignore:narrowing_conversion
				"south" : !roomOutline.get_pixel(x, clamp(y+1, -INF, roomOutline.get_height()-1) ).is_equal_approx(solidColor) and roomRect.has_point(Vector2(x, y+1)),
# warning-ignore:narrowing_conversion
				"west" : !roomOutline.get_pixel(clamp(x-1, 0, INF), y).is_equal_approx(solidColor) and roomRect.has_point(Vector2(x-1, y)),
# warning-ignore:narrowing_conversion
				"east" : !roomOutline.get_pixel(clamp(x+1, -INF, roomOutline.get_width()-1), y).is_equal_approx(solidColor) and roomRect.has_point(Vector2(x+1, y))
			}

			connectionMap[x].append(roomConnections)

	# Creating the room layout
	for x in roomOutline.get_width():
		for y in roomOutline.get_height():

			# Getting the prefab section color
			var rLayoutP = roomOutline.get_pixel(x, y)

			if !rLayoutP.is_equal_approx(solidColor):
				# Otherwise, select a prefab to use
				viablePrefabs.shuffle()
				var prefab:Image = load(prefabs % viablePrefabs.pop_front()).get_data()
				prefab.lock()

				var exitDirection = get_dir(rLayoutP)

				for xx in prefab.get_width():
					for yy in prefab.get_height():
						# Creating the prefab in the room
						var tileColor = prefab.get_pixel(xx, yy)
						var direction = get_dir(tileColor)

						# Checking for ground
						if tileColor.is_equal_approx(emptyColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)
						# Checking for an enemy
						elif tileColor.is_equal_approx(ruinColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), ruinColor)
						# Checking for an enemy
						elif tileColor.is_equal_approx(enemyColor):
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), enemyColor)

						# Checking the directions
						elif direction == NORTH and (connectionMap[x][y].north or exitDirection == NORTH): # NORTH
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)
						elif direction == SOUTH and (connectionMap[x][y].south or exitDirection == SOUTH): # SOUTH
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)
						elif direction == EAST and (connectionMap[x][y].east or exitDirection == EAST): # EAST
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)
						elif direction == WEST and (connectionMap[x][y].west or exitDirection == WEST): # WEST
							roomLayout.set_pixel(xx+(x*prefabSize), yy+(y*prefabSize), emptyColor)



	var ca = CellularAutomata.new()
	roomLayout = ca.iterate(roomLayout, planet.CAIterations, planet.CAStarveLimit, planet.CAOverPop, solidColor)
	ca.queue_free()

	roomLayout.save_png("user://output.png")

	return roomLayout


func get_dir(color:Color):
	if color.is_equal_approx(northColor):
		return NORTH
	if color.is_equal_approx(southColor):
		return SOUTH
	if color.is_equal_approx(eastColor):
		return EAST
	if color.is_equal_approx(westColor):
		return WEST
	return NONE




