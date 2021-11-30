extends Reference
class_name WorldGenerator

const BLOCKING_ROOM = Color("#151d28")
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
	
	grow_world()
	
	return rooms


func grow_world(growLoops_:int=growLoops) -> void:
	for i in 3:#growLoops_:
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
				if (allBiomesSame and rand_range(0, 1) < 0.333)\
				and !room.blockGrowing:
					changes.append({
						"pos" : Vector2(x, y),
						"to" : goodBiome
					})
		for c in changes:
			rooms[c.pos.x][c.pos.y].biome = c.to


func get_biome_by_color(color:Color):
	var biomes = [
		"res://World/Biomes/Lab.tres", 
		"res://World/Biomes/DeepLabs.tres",
		"res://World/Biomes/Caves.tres"
	]
	for b in biomes:
		var biome = load(b)
		if biome.mapColor.is_equal_approx(color) or\
		(biome.startingArea and color.is_equal_approx(STARTING_ROOM)):
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

