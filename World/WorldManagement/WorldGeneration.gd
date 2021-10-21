extends Reference
class_name WorldGenerator

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
		for i in blowUpSize:
			rooms.append([])
			
			for y in template.get_height():
				for j in blowUpSize:
					var color = template.get_pixel(x, y)
					var biome = get_biome_by_color(color)
					
					rooms[(x*blowUpSize)+i].append({
						"color" : color,
						"biome" : biome,
						"constantRoom" : null,
						"roomIcon" : null,
						"connections" : []
					})
	
	remove_2x2_areas()
	grow_world()
	remove_surrounded_tiles()
	

	for x in rooms.size():
		for y in rooms[0].size():
			var room = rooms[x][y]
			if room.biome:
				if !room.biome.name in biomes.keys():
					biomes[room.biome.name] = []
				biomes[room.biome.name].append(Vector2(x, y))
			var neighbors = get_neighbors(Vector2(x, y), false, false)
			if neighbors.size() == 0:
				rooms[x][y].biome = null
				continue
			for i in neighbors:
				if rooms[i.x][i.y].biome != rooms[x][y].biome:
					if room.biome: if room.biome.name != "Labs": break
					
					rooms[x][y].constantRoom = preload("res://World/ConstantRooms/Rooms/DeepLabsBlock.tres")
	
	for i in constantRooms.rooms.duplicate():
		var position:Vector2
		for _j in int(rand_range(i.usesMin+1, i.usesMax)):
			if i.biome:
				while true:
					var biome = biomes[i.biome.name]
					biome.shuffle()
					position = biome.front()
					if !rooms[position.x][position.y].constantRoom:
						break
			else:
				var width = rooms.size()
				var height = rooms[0].size()
				while true:
					position = Vector2(
						rand_range(0, width-1),
						rand_range(0, height-1)).round()
					if rooms[position.x][position.y].biome != null:
						break
			rooms[position.x][position.y].constantRoom = i
			rooms[position.x][position.y].roomIcon = i.roomIcon
	
	return rooms
	


func remove_2x2_areas() -> void:
	var points := []
	
	for i in removalPointCount:
		var dropPlace:Vector2
		var attempts := 0
		
		while true:
			dropPlace = Vector2(
				rand_range(1, rooms.size()-1),
				rand_range(1, rooms[0].size()-1)
			).round()
			
			# Checking if the spot is valid
			var farEnough = true
			for p in points:
				farEnough = dropPlace.distance_to(p) > 3.25
				if !farEnough: break
			var valid = farEnough#get_neighbors(dropPlace).size() == 8 and farEnough
			
			# Adding the point if the spot if valid
			if rooms[dropPlace.x][dropPlace.y].biome and valid:
				points.append(dropPlace)
				break
			
			# Breaking out if it tried too much
			if attempts >= 100: break
			attempts += 1

	for i in points:
		var x := clamp(i.x+1, 0, rooms.size()-1)
		var y := clamp(i.y+1, 0, rooms[0].size()-1)
		rooms[i.x][i.y].biome = null
		rooms[x][i.y].biome = null
		rooms[i.x][y].biome = null
		rooms[x][y].biome = null


func grow_world(growLoops_:int=growLoops) -> void:
	for i in growLoops_:
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
				if allBiomesSame and rand_range(0, 1) < goodBiome.growChance:
#					rooms[x][y].biome = goodBiome
					changes.append({
						"pos" : Vector2(x, y),
						"to" : goodBiome
					})
		for c in changes:
			rooms[c.pos.x][c.pos.y].biome = c.to


func remove_surrounded_tiles() -> void:
	var removals = []
	# Finding unneeded rooms
	for x in rooms.size():
		for y in rooms[0].size():
			var room = rooms[x][y]
			if !room.biome: continue
			
			# Checking if it's a valid removable room
			if get_neighbors(Vector2(x, y)).size() == 8\
			and rand_range(0, 1) < room.biome.middleRemovalChance:
				removals.append(Vector2(x, y))
	# Removing rooms
	for i in removals:
		rooms[i.x][i.y].biome = null


func connect_rooms() -> void:
	for x in rooms.size():
		for y in rooms[0].size():
			var neighbors = get_neighbors(Vector2(x, y), false, false)
			neighbors.shuffle()
			for i in neighbors:
				if rooms[i.x][i.y].biome == rooms[x][y].biome:
					if rand_range(0, 1) > rooms[i.x][i.y].biome.connectionChance:
						continue
					var connection = i-Vector2(x, y)
					rooms[x][y].connections.append(connection)
					rooms[i.x][i.y].connections.append(-connection)
					break


func get_biome_by_color(color:Color):
	var biomes = [
		"res://World/Biomes/Lab.tres", 
		"res://World/Biomes/DeepLabs.tres",
		"res://World/Biomes/Caves.tres"
	]
	for b in biomes:
		var biome = load(b)
		if biome.mapColor.is_equal_approx(color):
			return biome
	return null


func select_template() -> Image:
	return load("res://World/Templates/WorldTemplates/Template%s.png" % ceil(rand_range(0, 5))).get_data()


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

