extends Node2D

const PADDING := 10

onready var world := get_parent()


var worldData = preload("res://World/WorldManagement/WorldData.tres")
var biome:WorldArea
var room:Node
var roomI:Image


func _ready() -> void:
	var _discard = connect("tree_exiting", self, "_on_tree_exiting")
func _on_tree_exiting() -> void:
	if room: room.queue_free()

func create_room() -> void:
	AudioServer.set_bus_effect_enabled(4, 0, true)
	seed(worldData.position.x*worldData.position.y)
	
	for t in world.tilesContainer.get_children():
		t.queue_free()
	biome = worldData.rooms\
		[worldData.position.x][worldData.position.y].biome
	
	# Adding in the nodes
	world.solids = biome.solids.instance()
	world.solids.z_index = 1
	world.tilesContainer.add_child(world.solids)
	
	world.platforms = biome.platforms.instance()
	world.platforms.z_index = -1
	world.tilesContainer.add_child(world.platforms)
	
	world.background = biome.background.instance()
	world.background.z_index = -3
	world.tilesContainer.add_child(world.background)
	
	world.solidColorBG.color = biome.bgColor
	world.mistSpawner.color = biome.mistColor
	
	# Setup
	var connections:Array = worldData.get_connected_rooms(worldData.position)
	
	worldData.rooms[worldData.position.x][worldData.position.y].discovered = true
	for i in worldData.get_connected_rooms(worldData.position):
		worldData.rooms[worldData.position.x+i.x][worldData.position.y+i.y].nearDiscovered = true
	
	var cr = worldData.rooms[worldData.position.x][worldData.position.y].constantRoom
	if cr: room = cr.scene.instance()
	
	# Adding the tiles
	if room:
		create_constant_room(connections)
	else:
		create_random_room(connections)
	
	var roomSize = world.solids.get_used_rect().end
	create_loading_zone(Vector2(-24/16, roomSize.y*.5)*16, Vector2(32/16, roomSize.y*.5)*16, Vector2.LEFT) # Left
	create_loading_zone(Vector2(roomSize.x+(24/16), roomSize.y*.5)*16, Vector2(32/16, roomSize.y*.5)*16, Vector2.RIGHT) # Right
	create_loading_zone(Vector2(roomSize.x*.5, -24/16)*16, Vector2(roomSize.x*.5, 32/16)*16, Vector2.UP) # Up
	create_loading_zone(Vector2(roomSize.x*.5, roomSize.y+(24/16))*16, Vector2(roomSize.x*.5, 32/16)*16, Vector2.DOWN) # Down
	
	# Setting camera limits
	var camMoveShape = world.mainCamMove.collisionShape.shape.duplicate()
	var limits = world.solids.get_used_rect()

	limits.position = world.solids.map_to_world(limits.position)
	limits.end = world.solids.map_to_world(limits.end)
	
	var offset:Vector2 = get_viewport_rect().end-limits.end
	offset.x = clamp(offset.x, 0, INF); offset.y = clamp(offset.y, 0, INF)
	
	limits.end.x = clamp(limits.end.x, get_viewport_rect().end.x, INF)
	limits.end.y = clamp(limits.end.y, get_viewport_rect().end.y, INF)
	
	world.mainCamMove.position = (limits.end*.5).abs()
	world.mainCamMove.position -= offset*.5
	camMoveShape.extents = (limits.end*.5).abs()
	
	world.mainCamMove.collisionShape.shape = camMoveShape
	
	# Setting player position
	set_player_pos()
	
	# PADDING
	pad(Vector2(0, -PADDING), Vector2(0, roomSize.y+PADDING), Vector2.DOWN, Vector2.LEFT)
	pad(Vector2(roomSize.x-1, -PADDING), Vector2(roomSize.x-1, roomSize.y+PADDING), Vector2.DOWN, Vector2.RIGHT)
	pad(Vector2(-PADDING, 0), Vector2(roomSize.x+PADDING, 0), Vector2.RIGHT, Vector2.UP)
	pad(Vector2(-PADDING, roomSize.y-1), Vector2(roomSize.x+PADDING, roomSize.y-1), Vector2.RIGHT, Vector2.DOWN)

	if worldData.rooms[worldData.position.x-worldData.moveDir.x]\
	[worldData.position.y-worldData.moveDir.y].biome != biome\
	or worldData.moveDir == Vector2.ZERO:
		var newBiomeTitle = preload("res://UI/BiomeTitle/BiomeTitle.tscn").instance()
		world.canvasLayer.add_child(newBiomeTitle)
		newBiomeTitle.get_node("Title/Name").text = "The "+biome.name

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func create_constant_room(connections) -> void:
	add_child(room)
	room.hide()
	# Solids
	var roomS:TileMap = room.solids
	for i in roomS.get_used_cells():
		world.solids.set_cellv(i, roomS.get_cellv(i))
		world.solids.update_bitmask_area(i)
		world.background.set_cellv(i, roomS.get_cellv(i))
		world.background.update_bitmask_area(i)
	# Background
	var roomBG:TileMap = room.BG
	for i in roomBG.get_used_cells():
		world.background.set_cellv(i, roomBG.get_cellv(i))
		world.background.update_bitmask_area(i)
	# Platforms
	var roomP:TileMap = room.platforms
	for i in roomP.get_used_cells():
		world.platforms.set_cellv(i, roomP.get_cellv(i))
		world.platforms.update_bitmask_area(i)
		world.background.set_cellv(i, roomP.get_cellv(i))
		world.background.update_bitmask_area(i)
	# Roof Props
	var roomCeilProps:TileMap = room.ceilingProp
	for i in roomCeilProps.get_used_cells():
		if biome.roofProps.size() > 0: add_props(biome.roofProps, i.x, i.y)
	# Floor Props
	var roomFloorprops:TileMap = room.groundProp
	for i in roomFloorprops.get_used_cells():
		if biome.groundProps.size() > 0: add_props(biome.groundProps, i.x, i.y+1)
	# Props
	var roomPr:Node2D = room.props
	for c in roomPr.get_children():
		roomPr.remove_child(c)
		add_child(c)
	# Tiling over none connected rooms
	var size = world.solids.get_used_rect().end-Vector2.ONE
	var nonconnections = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
	for i in connections: nonconnections.erase(i)
	for i in nonconnections:
		match i:
			Vector2.UP:
				for x in size.x:
					var pos = Vector2(x, 0)
					world.solids.set_cellv(pos, 0)
					world.solids.update_bitmask_area(pos)
			Vector2.DOWN:
				for x in size.x:
					var pos = Vector2(x, size.y)
					world.solids.set_cellv(pos, 0)
					world.platforms.set_cellv(pos, -1)
					world.solids.update_bitmask_area(pos)
			Vector2.RIGHT:
				for y in size.y:
					var pos = Vector2(size.x, y)
					world.solids.set_cellv(pos, 0)
					world.solids.update_bitmask_area(pos)
			Vector2.LEFT:
				for y in size.y:
					var pos = Vector2(0, y)
					world.solids.set_cellv(pos, 0)
					world.solids.update_bitmask_area(pos)

func create_random_room(connections) -> void:
	roomI = RoomGenerator.generate(
		randi(),
		biome.roomTemplates,
# warning-ignore:integer_division
		int(float(biome.roomTemplates.get_width())/float(RoomGenerator.TEMPLATE_SIZE)),
		connections
	)
	
	var viableContainerSpawns = []
	
	var containers = [
		preload("res://World/Props/Containers/Safe/Safe.tscn"),
		preload("res://World/Props/Containers/Locker/Locker.tscn")
	]
	
	# Placing the props
	roomI.lock()
	for x in roomI.get_width():
		for y in roomI.get_height():
			var pixel:Color = roomI.get_pixel(x, y)
			# If is solid tile
			if pixel.is_equal_approx(RoomGenerator.TILE):
				world.solids.set_cell(x, y, 0)
				world.solids.update_bitmask_area(Vector2(x, y))
				
# warning-ignore:narrowing_conversion
				if rand_range(0, 1) < .5 and roomI.get_pixel(x, clamp(y+1, 0, roomI.get_height()-1)).is_equal_approx(RoomGenerator.EMPTY):
					if biome.roofProps.size() > 0: add_props(biome.roofProps, x, y+1)
# warning-ignore:narrowing_conversion
				if rand_range(0, 1) < .5 and roomI.get_pixel(x, clamp(y-1, 0, roomI.get_height()-1)).is_equal_approx(RoomGenerator.EMPTY):
					if biome.groundProps.size() > 0: add_props(biome.groundProps, clamp(x, 2, roomI.get_width()-2), y)
					viableContainerSpawns.append(Vector2(x, y))
			# If is platform
			elif pixel.is_equal_approx(RoomGenerator.PLATFORM):
				world.platforms.set_cell(x, y, 0)
				world.platforms.update_bitmask_area(Vector2(x, y))
				
				world.background.set_cell(x, y, 0)
				world.background.update_bitmask_area(Vector2(x, y))
				var plus = Vector2(rand_range(-1, 1), rand_range(-1, 1)).round()
				world.background.set_cell(x+plus.x, y+plus.y, 0)
				world.background.update_bitmask_area(Vector2(x, y)+plus)
				
				viableContainerSpawns.append(Vector2(x, y-1))
			# If is empty
			if roomI.get_pixel(x, y).is_equal_approx(RoomGenerator.EMPTY):
				world.viableEnemySpawns.append(Vector2(x, y))
	
	viableContainerSpawns.shuffle()
	for i in Globals.MAX_CONTAINERS:
		if viableContainerSpawns.size() == 0: 
			break
		var spawnPos:Vector2 = viableContainerSpawns.pop_front()
		add_props(containers, spawnPos.x, spawnPos.y)
		
	
	# Enemy Spawning
	spawn_enemies()
	
	# Blocking off exits
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
	for i in dirs:
		var blockOff := preload("res://World/Props/DoorBlock/DoorBlock.tscn").instance()
		var collisionShape := RectangleShape2D.new()
		
		var extents:Vector2 = world.solids.get_used_rect().end
		match i:
			Vector2.UP:
				var collisionSize = (extents.x*.5)*world.solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)
				
				blockOff.scale.x = -1
				blockOff.rotation_degrees = 90
				blockOff.position = Vector2((extents.x*.5), 0)
			Vector2.DOWN:
				var collisionSize = (extents.x*.5)*world.solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)
				
				blockOff.rotation_degrees = 90
				blockOff.position = Vector2((extents.x*.5), extents.y)
			Vector2.RIGHT:
				var collisionSize = (extents.y*.5)*world.solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)
				
				blockOff.position = Vector2(extents.x, (extents.y*.5))
			Vector2.LEFT:
				var collisionSize = (extents.y*.5)*world.solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)
				
				blockOff.scale.x = -1
				blockOff.position = Vector2(0, (extents.y*.5))
		
		add_child(blockOff)
		blockOff.position *= world.solids.cell_size
		blockOff.position = blockOff.position.round()
		blockOff.collision.shape = collisionShape
		blockOff.position_sprite()
		
		world.exitBlockers.append(blockOff)

func create_loading_zone(pos:Vector2, size:Vector2, direction:Vector2) -> void:
	var area = Area2D.new()
	area.position = pos+((direction*2)*16)
	add_child(area)
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = size
	collision.shape = shape
	area.add_child(collision)
	
	area.collision_layer = 0
	area.collision_mask = 2
	area.connect("area_entered", world, "_on_load_area", [direction])

func set_player_pos() -> void:
	var size = world.solids.get_used_rect().end
	match worldData.moveDir:
		Vector2.RIGHT:
			var ppos = get_free_spot(Vector2.ZERO, Vector2(0, size.y), Vector2.DOWN).end
			ppos.x += 1.8
			world.player.position = ppos*world.solids.cell_size
			world.player.position.y -= 8
		Vector2.LEFT:
			var ppos = get_free_spot(Vector2(size.x-1, 0), Vector2(size.x-1, size.y), Vector2.DOWN).end
			ppos.x -= 1.8
			world.player.position = ppos*world.solids.cell_size
			world.player.position.y -= 8
		Vector2.UP:
			var positions = get_free_spot(Vector2(0, size.y-1), Vector2(size.x, size.y-1), Vector2.RIGHT)
			var x = (positions.end.x-positions.start.x)*.5
			var ppos = Vector2(positions.start.x+x, size.y-2)
			world.player.position = ppos*world.solids.cell_size
			world.player.vel.y = -world.player.playerData.jumpForce
		Vector2.DOWN:
			var positions = get_free_spot(Vector2.ZERO, Vector2(size.x, 0), Vector2.RIGHT)
			var x = (positions.end.x-positions.start.x)*.5
			var ppos = Vector2(positions.start.x+x, 2)
			world.player.position = ppos*world.solids.cell_size
	while world.solids.get_cellv(world.solids.world_to_map(world.player.position)) != -1:
		world.player.position.y -= world.solids.cell_size.y

func pad(startPos:Vector2, endPos:Vector2, incDir:Vector2, padDir:Vector2) -> void:
	var pos = startPos
	
	while pos != endPos:
		if world.solids.get_cellv(pos) > -1:
			for i in PADDING:
				var updatePos:Vector2 = pos+(padDir*i)
				world.solids.set_cellv(updatePos, 0)
				world.solids.update_bitmask_area(updatePos)
				world.background.set_cellv(updatePos, 0)
				world.background.update_bitmask_area(updatePos)
		else:
			for i in PADDING:
				var updatePos:Vector2 = pos+(padDir*i)
				world.background.set_cellv(updatePos, 0)
				world.background.update_bitmask_area(updatePos)
				
				var plus = Vector2(rand_range(-1, 1), rand_range(-1, 1)).round()
				world.background.set_cellv(updatePos+plus, 0)
				world.background.update_bitmask_area(updatePos+plus)
		pos += incDir

func add_props(propArr:Array, x, y) -> void:
	propArr.shuffle()
	var prop = propArr.front().instance()
	prop.position = Vector2(x, y)*world.solids.cell_size
	prop.position.x += world.solids.cell_size.x*.5
	prop.z_index = -2
	world.props.add_child(prop)

func spawn_enemies() -> void: 
	if !roomI is Image:
		print("Get trolled: %s" % roomI)
		return
	randomize()
	world.viableEnemySpawns.shuffle()
	var enemyPool = biome.enemyPools[rand_range(0, biome.enemyPools.size()-1)]
# warning-ignore:integer_division
# warning-ignore:integer_division
	for i in ceil((roomI.get_width()/Globals.TEMPLATE_SIZE)*(roomI.get_height()/Globals.TEMPLATE_SIZE)):
		if world.viableEnemySpawns.size() == 0:
			break
		var spawnPos:Vector2 = world.viableEnemySpawns.pop_front()
		var spawner = preload(\
			"res://Entities/Effects/EnemySpawn.tscn").instance()
		spawner.position = spawnPos*world.solids.cell_size
		spawner.position.x += world.solids.cell_size.x*.5
		spawner.enemyPool = enemyPool
		
		world.enemies.add_child(spawner)

func get_free_spot(startPos:Vector2, endPos:Vector2, incDir:Vector2) -> Dictionary:
	var firstUpdatedPos := startPos
	var lastUpdatedPos := startPos
	var updateCount = 0
	var i := startPos
	
	while i != endPos:
		if world.solids.get_cellv(i) == -1:
			if updateCount == 0: firstUpdatedPos = i
			lastUpdatedPos = i
			updateCount += 1
		i += incDir
	
	return {
		"start" : firstUpdatedPos,
		"end" : lastUpdatedPos
	}
