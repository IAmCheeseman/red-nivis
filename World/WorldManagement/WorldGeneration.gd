extends Reference
class_name WorldGenerator

const BLOCKING_ROOM    = Color("#000000")
const STARTING_ROOM    = Color("#a8ca58")
const BOSS_ROOM        = Color("#ff0000")
const CONNECTION_COLOR = Color("#4d2b32")

export var growLoops := 2
export var growChance := .222

var rooms = []
var constantRoomUseage = []

const BIOMES = [
	preload("res://World/Biomes/Lab.tres"),
	preload("res://World/Biomes/Freezers.tres"),
	preload("res://World/Biomes/ChemLabs.tres"),
	preload("res://World/Biomes/DeepLabs.tres"),
]


func generate_world(seed_:int=randi(), dontPick: String="") -> Dictionary:
	seed(seed_)
	# Creating and filling out the 2D array
	var data := select_template(dontPick)
	var template: Image = data.template
	template.lock()
	
	var constantRooms = preload("res://World/ConstantRooms/Rooms.tres")

	for i in constantRooms.rooms:
		constantRoomUseage.append(0)

	for x in template.get_width():
		rooms.append([])
		for y in template.get_height():
			var color = template.get_pixel(x, y)
			var biome = get_biome_by_color(color)
			var room = {
				"color"             : color,
				"possibleBiome"     : get_biome_by_color(color, true),
				"isDodgeRoom"       : false,#randf() < 0.333,
				"biome"             : biome,
				"constantRoom"      : null,
				"roomIcon"          : null,
				"discovered"        : false,
				"nearDiscovered"    : false,
				"typeAlwaysVisible" : false,
				"connections"       : [],
				"cleared"           : false,
				"isStartingRoom"    : color.is_equal_approx(STARTING_ROOM),
				"blockGrowing"      : color.is_equal_approx(BLOCKING_ROOM),
				"bossRoom"          : color.is_equal_approx(BOSS_ROOM),
				"isBiomeConnection" : color.is_equal_approx(CONNECTION_COLOR),
				"nodeData"          : {},
				"secret"            : false,
			}
			if room.isStartingRoom or room.bossRoom: room.isDodgeRoom = false
			if room.isStartingRoom:
				room.constantRoom = "res://World/ConstantRooms/Rooms/StartingRoom.tres"
			rooms[x].append(room)
	
	flood_world()
	grow_world()

	var br = preload("res://World/ConstantRooms/BossRooms.tres")
	BossRoomPlacer.generate_rooms(
		rooms, br.rooms, self
	)
	var cr = preload("res://World/ConstantRooms/Rooms.tres")
	for r in cr.rooms:
		RoomPlacer.generate_rooms(
			rooms, r, r.perBiome, r.minDistOfSameType, r.biomes, self)
	ConnectionRoomPlacer.generate_rooms(rooms, self)
	DodgeRoomPlacer.generate_rooms(rooms)
	
	return { "rooms": rooms, "template": data.path }

func flood_rooms(position:Vector2, what, searchfor) -> void:
	var neighbors = get_neighbors(position, true, false)
	rooms[position.x][position.y].biome = what
	rooms[position.x][position.y].possibleBiome = null
	for i in neighbors:
		var room = rooms[i.x][i.y]
		if room.possibleBiome == searchfor:
			flood_rooms(i, what, searchfor)


func flood_world() -> void:
	for x in rooms.size():
		for y in rooms[0].size():
			var room = rooms[x][y]
			if room.possibleBiome and rand_range(0, 1) < 1.0 / 3.0:
				flood_rooms(Vector2(x, y), room.possibleBiome, room.possibleBiome)
			elif room.possibleBiome and !room.biome:
				flood_rooms(Vector2(x, y), null, room.possibleBiome)


func grow_world() -> void:
	for i in growLoops:
		var changes = []
		for x in rooms.size():
			for y in rooms[0].size():

				# Checking the cell
				var room = rooms[x][y]
				if room.biome: continue

				var neighbors := get_neighbors(Vector2(x, y), false, false)
				var allBiomesSame := true
				var goodBiome:Resource

				# Looping through the neighbors
				for n in neighbors:
					var nr = rooms[n.x][n.y]

					# Checking if the biomes match
					if nr.biome:
						goodBiome = get_biome_by_index(nr.biome)
						for nn in neighbors:
							var neighbor = rooms[nn.x][nn.y]
							if get_biome_by_index(neighbor.biome) != goodBiome:
								allBiomesSame = false
								break
					else:
						continue
					if allBiomesSame:
						break

				if !goodBiome: continue
				if (allBiomesSame and rand_range(0, 1) < growChance)\
				and !room.blockGrowing:
					changes.append({
						"pos" : Vector2(x, y),
						"to" : goodBiome.biomeIndex,
						"secret" : i == growLoops-1 and rand_range(0, 1) < .75
					})
		for c in changes:
			rooms[c.pos.x][c.pos.y].biome = c.to
			rooms[c.pos.x][c.pos.y].secret = c.secret


func get_biome_by_color(color:Color, getSecondary:bool=false):
	for b in BIOMES.size():
		var biome = BIOMES[b]
		if biome.mapColor.is_equal_approx(color) or\
		(biome.startingArea and color.is_equal_approx(STARTING_ROOM)) and !getSecondary:
			return b
		elif biome.secondaryColor.is_equal_approx(color) and getSecondary:
			return b
	return null

func get_biome_by_index(idx: int):
	if idx == null: return null
	if idx > BIOMES.size(): return null
	return BIOMES[idx]


func get_used_rooms() -> Array:
	var usedRooms := []
	for x in rooms:
		for y in x:
			if y.biome:
				usedRooms.append(y)
	return usedRooms


func select_template(dontPick: String) -> Dictionary:
	var template: Image
	var path: String
	while true:
		path = "res://World/Templates/WorldTemplates/Template%s.png"\
					% ceil(rand_range(0, 1))
#		if path != dontPick:
		template = load(path).get_data()
		break
	
	return { "template": template, "path": path }


func get_neighbors(vec:Vector2, emptyNei:bool=false, corners:bool=true) -> Array:
	var neighbors := []
	var pos := Vector2(-1, -1)

	for i in 9:
		var v = Vector2(
			clamp(vec.x+pos.x, 0, rooms.size()-1),
			clamp(vec.y+pos.y, 0, rooms[0].size()-1)
		)
		if (rooms[v.x][v.y].biome == null) == emptyNei:
			if !(!corners and (pos.x in [-1, 1] and pos.y in [-1, 1])):
				neighbors.append(v)
		pos.x = wrapi(int(pos.x+1), -1, 2)
		if pos.x == -1: pos.y += 1
	neighbors.erase(vec)
	return neighbors

