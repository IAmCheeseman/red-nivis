extends Reference
class_name WorldGenerator

const BLOCKING_ROOM = Color("#000000")
const STARTING_ROOM = Color("#a8ca58")

export var blowUpSize := 3
export var growLoops := 2
export var removalPointCount := 100

var rooms = []
var constantRoomUseage = []


func generate_world(seed_:int=randi()) -> Array:
	seed(seed_)
	# Creating and filling out the 2D array
	var template := select_template()
	template.lock()
	
	var constantRooms = preload("res://World/ConstantRooms/Rooms.tres")
	
	for i in constantRooms.rooms:
		constantRoomUseage.append(0)
	
	var biomes = {}
	
	for x in template.get_width():
			rooms.append([])
			for y in template.get_height():
					var color = template.get_pixel(x, y)
					var biome = get_biome_by_color(color)
					
					var room = {
						"color" : color,
						"possibleBiome" : get_biome_by_color(color, true),
						"biome" : biome,
						"constantRoom" : null,
						"roomIcon" : null,
						"discovered" : false,
						"nearDiscovered" : false,
						"typeAlwaysVisible": false,
						"connections" : [],
						"cleared" : false,
						"isStartingRoom" : color.is_equal_approx(STARTING_ROOM),
						"blockGrowing" : color.is_equal_approx(BLOCKING_ROOM)
					}
					rooms[x].append(room)
	
	flood_world()
	grow_world()
	
	return rooms


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
			if room.possibleBiome and rand_range(0, 1) < 1.0/10.0:
				flood_rooms(Vector2(x, y), room.possibleBiome, room.possibleBiome)
			elif room.possibleBiome and !room.biome:
				flood_rooms(Vector2(x, y), null, room.possibleBiome)


func grow_world(growLoops_:int=growLoops) -> void:
	for i in 2:#growLoops_:
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
						goodBiome = nr.biome
						for nn in neighbors:
							var neighbor = rooms[nn.x][nn.y]
							if neighbor.biome != goodBiome:
								allBiomesSame = false
								break
					else:
						continue
					if allBiomesSame:
						break
				
				if !goodBiome: continue
				if (allBiomesSame and rand_range(0, 1) < .2)\
				and !room.blockGrowing:
					changes.append({
						"pos" : Vector2(x, y),
						"to" : goodBiome
					})
		for c in changes:
			rooms[c.pos.x][c.pos.y].biome = c.to


func get_biome_by_color(color:Color, getSecondary:bool=false):
	var biomes = [
		"res://World/Biomes/Lab.tres", 
		"res://World/Biomes/DeepLabs.tres",
		"res://World/Biomes/Caves.tres"
	]
	for b in biomes:
		var biome = load(b)
		if (biome.mapColor.is_equal_approx(color)) or\
		(biome.startingArea and color.is_equal_approx(STARTING_ROOM)) and !getSecondary:
			return biome
		elif biome.secondaryColor.is_equal_approx(color) and getSecondary:
			return biome
	return null


func select_template() -> Image:
	return load(
		"res://World/Templates/WorldTemplates/Template%s.png"\
		 % ceil(rand_range(0, 1)) ).get_data()


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

