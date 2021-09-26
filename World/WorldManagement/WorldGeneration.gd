extends Node2D

export var blowUpSize := 3
export var growChance := .5
export var growLoops := 3
export var middleRemovalChance := .666
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
					rooms[(x*blowUpSize)+i].append({
						"color" : template.get_pixel(x, y),
						"biome" : 0,
						"connections" : []
					})
	
	# Adding points to the map
	remove_2x2_areas()
	
	# Growing the world
	grow_world()

	# Removing fully surrounded cells
	remove_surrounded_tiles()
	
	grow_world()
	
	remove_surrounded_tiles()
	
	for x in rooms.size():
		for y in rooms[0].size():
			var neighbors = get_neighbors(Vector2(x, y), false, false)
			neighbors.shuffle()
			for i in neighbors:
				if !is_equal_approx(rooms[i.x][i.y].color.a, 0) and rand_range(0, 1) < .05:
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
			dropPlace = Vector2(rand_range(1, rooms.size()-1), rand_range(1, rooms[0].size()-1) ).round()
			
			# Checking if this drop is a good distance from other points
			var farEnoughAway = true
			for p in points:
				farEnoughAway = dropPlace.distance_to(p) > 2.9
				if !farEnoughAway: break
			
			if !is_equal_approx(rooms[dropPlace.x][dropPlace.y].color.a, 0) and farEnoughAway:
				points.append(dropPlace)
				break
			if attempts >= 100: break
			attempts += 1

	for i in points:
		rooms[i.x][i.y].color.a = 0
		rooms[clamp(i.x+1, 0, rooms.size()-1)][i.y].color.a = 0
		rooms[i.x][clamp(i.y+1, 0, rooms[0].size()-1)].color.a = 0
		rooms[clamp(i.x+1, 0, rooms.size()-1)][clamp(i.y+1, 0, rooms[0].size()-1)].color.a = 0


func grow_world():
	for i in growLoops:
		for x in rooms.size():
			for y in rooms[0].size():
				var neighbors = get_neighbors(Vector2(x, y), false, false)
				var allColorsSame = true
				var goodColor:Color
				for n in neighbors:
					var nr = rooms[n.x][n.y]
					if !is_equal_approx(nr.color.a, 0):
						goodColor = nr.color
						for nn in neighbors:
							if !rooms[nn.x][nn.y].color.is_equal_approx(nr.color):
								allColorsSame = false
								break
					else:
						continue
					if allColorsSame:
						break
				if allColorsSame and rand_range(0, 1) < growChance:
					rooms[x][y].color = goodColor


func remove_surrounded_tiles():
	var removals = []
	for x in rooms.size():
		for y in rooms[0].size():
			if get_neighbors(Vector2(x, y)).size() == 8 and rand_range(0, 1) < middleRemovalChance:
				removals.append(Vector2(x, y))
	for i in removals:
		rooms[i.x][i.y].color.a = 0


func select_template() -> Image:
	return load("res://Template%s.png" % round(rand_range(1, 4))).get_data()


func get_neighbors(vec:Vector2, emptyNei:bool=false, corners:bool=true) -> Array:
	var neighbors := []
	var pos := Vector2(-1, -1)
	
	for i in 9:
		if is_equal_approx(rooms[clamp(vec.x+pos.x, 0, rooms.size()-1)][clamp(vec.y+pos.y, 0, rooms[0].size()-1)].color.a, 0) == emptyNei:
			if !(!corners and (pos.x in [-1, 1] and pos.y in [-1, 1])):
				neighbors.append(Vector2(clamp(vec.x+pos.x, 0, rooms.size()-1), clamp(vec.y+pos.y, 0, rooms[0].size()-1)))
		pos.x = wrapi(int(pos.x+1), -1, 2)
		if pos.x == -1: pos.y += 1
	neighbors.erase(vec)
	return neighbors


func _draw() -> void:
	for x in rooms.size():
		for y in rooms[x].size():
			var color = rooms[x][y].color
			draw_rect(Rect2(x*11, y*11, 10, 10), color)
			for i in rooms[x][y].connections:
				match i:
					Vector2.UP:
						draw_rect(Rect2(x*11, y*11-1, 10, 1), color)
					Vector2.DOWN:
						draw_rect(Rect2(x*11, y*11+10, 10, 1), color)
					Vector2.LEFT:
						draw_rect(Rect2(x*11-1, y*11, 1, 10), color)
					Vector2.RIGHT:
						draw_rect(Rect2(x*11+10, y*11, 1, 10), color)

