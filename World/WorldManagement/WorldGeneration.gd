extends Node2D

export var blowUpSize := 3
export var growChance := .5
export var growLoops := 5
export var middleRemovalChance := .333
export var removalPointCount := 100

var rooms = []


func _ready() -> void:
	randomize()
	generate_world()
	update()


func generate_world() -> void:
	# Creating and filling out the 2D array
	var template := select_template()
	template.lock()
	for x in template.get_width():
		for i in blowUpSize:
			rooms.append([])
			
			for y in template.get_height():
				for j in blowUpSize:
					var color = template.get_pixel(x, y)
					rooms[(x*blowUpSize)+i].append({
						"color" : color,
						"biome" : get_biome_by_color(color),
						"connections" : []
					})
	
	grow_world()
	remove_2x2_areas()
#	remove_surrounded_tiles()
	
	
	# Connecting rooms to make bigger rooms
	for x in rooms.size():
		for y in rooms[0].size():
			var neighbors = get_neighbors(Vector2(x, y), false, false)
			neighbors.shuffle()
			for i in neighbors:
				if rooms[i.x][i.y].biome and rand_range(0, 1) < .05:
					var connection = i-Vector2(x, y)
					rooms[x][y].connections.append(connection)
					rooms[i.x][i.y].connections.append(-connection)
					break
	
	for x in rooms.size():
		for y in rooms[0].size():
			if get_neighbors(Vector2(x, y), false, false).size() == 0:
				rooms[x][y].color.a = 0


func remove_2x2_areas():
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
			var valid = true
			for p in points:
				valid = dropPlace.distance_to(p) > 2.9
				if !valid: break
			
			# Adding the point if the spot if valid
			if rooms[dropPlace.x][dropPlace.y].biome and valid:
				points.append(dropPlace)
				break
			
			# Breaking out if it tried too much
			if attempts >= 100: break
			attempts += 1

	for i in points:
		rooms[i.x][i.y].color.a = 0
		rooms[clamp(i.x+1, 0, rooms.size()-1)][i.y].color.a = 0
		rooms[i.x][clamp(i.y+1, 0, rooms[0].size()-1)].color.a = 0
		rooms[clamp(i.x+1, 0, rooms.size()-1)][clamp(i.y+1, 0, rooms[0].size()-1)].color.a = 0


func grow_world():
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


func remove_surrounded_tiles():
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


func get_biome_by_color(color:Color):
	var biomes = ["res://World/Biomes/Lab.tres", "res://World/Biomes/DeepLabs.tres"]
	for b in biomes:
		var biome = load(b)
		if biome.mapColor.is_equal_approx(color):
			return biome
	return null


func select_template() -> Image:
	return load("res://World/Templates/WorldTemplates/Template%s.png" % round(rand_range(1, 4))).get_data()


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


func _draw() -> void:
	for x in rooms.size():
		for y in rooms[x].size():
			if !rooms[x][y].biome:
				continue
				
			var color = rooms[x][y].biome.mapColor
			draw_rect(Rect2(x*6, y*6, 5, 5), color)
			for i in rooms[x][y].connections:
				match i:
					Vector2.UP:
						draw_rect(Rect2(x*6, y*6-1, 5, 1), color)
					Vector2.DOWN:
						draw_rect(Rect2(x*6, y*6+5, 5, 1), color)
					Vector2.LEFT:
						draw_rect(Rect2(x*6-1, y*6, 1, 5), color)
					Vector2.RIGHT:
						draw_rect(Rect2(x*6+5, y*6, 1, 5), color)

