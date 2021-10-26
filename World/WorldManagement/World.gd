extends Node2D

const PADDING = 10

onready var player = $Props/Player
onready var props = $Props
onready var atmosphere = $Atmosphere
onready var mistSpawner = $Props/Player/MistSpawner
onready var solids = $Props/Tiles/LabSolids
onready var platforms = $Props/Tiles/OneWayPlatforms
onready var solidColorBG = $Background/BGColor
onready var canvasLayer =$CanvasLayer
onready var mainCamMove = $Props/CameraZones/CameraMoveZone
onready var screenTrans = $ScreenTransition
onready var tilesContainer = $Props/Tiles
onready var enemies = $Props/Enemies
onready var roomClearer = $RoomClearer

var worldData = preload("res://World/WorldManagement/WorldData.tres")

var exitBlockers = []

func _ready():
	AudioServer.set_bus_effect_enabled(4, 0, true)
	seed(worldData.position.x*worldData.position.y)
	
	for t in tilesContainer.get_children():
		t.queue_free()
	var biome:WorldArea = worldData.rooms\
		[worldData.position.x][worldData.position.y].biome
	
	solids = biome.solids.instance()
	solids.z_index = 1
	
	tilesContainer.add_child(solids)
	platforms = biome.platforms.instance()
	platforms.z_index = -1
	tilesContainer.add_child(platforms)
	
	solidColorBG.color = biome.bgColor
	mistSpawner.color = biome.mistColor
	
	var connections:Array = worldData.get_connected_rooms(worldData.position)
	var room
	
	worldData.rooms[worldData.position.x][worldData.position.y].discovered = true
	for i in worldData.get_connected_rooms(worldData.position):
		worldData.rooms[worldData.position.x+i.x][worldData.position.y+i.y].nearDiscovered = true
	
	# CONSTANT ROOMS
	
	var cr = worldData.rooms[worldData.position.x][worldData.position.y].constantRoom
	if cr: room = cr.scene.instance()
	
	if room:
		add_child(room)
		
		# Solids
		var roomS:TileMap = room.solids
		for i in roomS.get_used_cells():
			solids.set_cellv(i, roomS.get_cellv(i))
			solids.update_bitmask_area(i)
		
		# Platforms
		var roomP:TileMap = room.platforms
		for i in roomP.get_used_cells():
			platforms.set_cellv(i, roomP.get_cellv(i))
			platforms.update_bitmask_area(i)
		
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
		var size = solids.get_used_rect().end-Vector2.ONE
		var nonconnections = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
		for i in connections: nonconnections.erase(i)
		for i in nonconnections:
			match i:
				Vector2.UP:
					for x in size.x:
						var pos = Vector2(x, 0)
						solids.set_cellv(pos, 0)
						solids.update_bitmask_area(pos)
				Vector2.DOWN:
					for x in size.x:
						var pos = Vector2(x, size.y)
						solids.set_cellv(pos, 0)
						platforms.set_cellv(pos, -1)
						solids.update_bitmask_area(pos)
				Vector2.RIGHT:
					for y in size.y:
						var pos = Vector2(size.x, y)
						solids.set_cellv(pos, 0)
						solids.update_bitmask_area(pos)
				Vector2.LEFT:
					for y in size.y:
						var pos = Vector2(0, y)
						solids.set_cellv(pos, 0)
						solids.update_bitmask_area(pos)
		room.queue_free()
	# RANDOM ROOMS
	else:
		room = RoomGenerator.generate(
			randi(),
			biome.roomTemplates,
# warning-ignore:integer_division
			int(float(biome.roomTemplates.get_width())/float(RoomGenerator.TEMPLATE_SIZE)),
			connections
		)
		
		var viableEnemySpawns = [] 
		var viableContainerSpawns = []
		
		var containers = [
			preload("res://World/Props/Containers/Safe/Safe.tscn"),
			preload("res://World/Props/Containers/Locker/Locker.tscn")
		]
		
		room.lock()
		for x in room.get_width():
			for y in room.get_height():
				var pixel:Color = room.get_pixel(x, y)
				# If is solid tile
				if pixel.is_equal_approx(RoomGenerator.TILE):
					solids.set_cell(x, y, 0)
					solids.update_bitmask_area(Vector2(x, y))
					
	# warning-ignore:narrowing_conversion
					if rand_range(0, 1) < .5 and room.get_pixel(x, clamp(y+1, 0, room.get_height()-1)).is_equal_approx(RoomGenerator.EMPTY):
						if biome.roofProps.size() > 0: add_props(biome.roofProps, x, y+1)
	# warning-ignore:narrowing_conversion
					if rand_range(0, 1) < .5 and room.get_pixel(x, clamp(y-1, 0, room.get_height()-1)).is_equal_approx(RoomGenerator.EMPTY):
						if biome.groundProps.size() > 0: add_props(biome.groundProps, clamp(x, 2, room.get_width()-2), y)
						viableContainerSpawns.append(Vector2(x, y))
				# If is platform
				elif pixel.is_equal_approx(RoomGenerator.PLATFORM):
					platforms.set_cell(x, y, 0)
					platforms.update_bitmask_area(Vector2(x, y))
				# If is empty
				if room.get_pixel(x, y).is_equal_approx(RoomGenerator.EMPTY):
					viableEnemySpawns.append(Vector2(x, y))
		
		viableContainerSpawns.shuffle()
		for i in Globals.MAX_CONTAINERS:
			if viableContainerSpawns.size() == 0: 
				break
			var spawnPos:Vector2 = viableContainerSpawns.pop_front()
			add_props(containers, spawnPos.x, spawnPos.y)
			
		
		# Enemy Spawning
		randomize()
		viableEnemySpawns.shuffle()
		var enemyPool = biome.enemyPools[rand_range(0, biome.enemyPools.size()-1)]
	# warning-ignore:integer_division
	# warning-ignore:integer_division
		for i in ceil((room.get_width()/Globals.TEMPLATE_SIZE)*(room.get_height()/Globals.TEMPLATE_SIZE)):
			if viableEnemySpawns.size() == 0:
				break
			var spawnPos:Vector2 = viableEnemySpawns.pop_front()
			var spawner = preload(\
				"res://Entities/Effects/EnemySpawn.tscn").instance()
			spawner.position = spawnPos*solids.cell_size
			spawner.position.x += solids.cell_size.x*.5
			spawner.enemyPool = enemyPool
			
			enemies.add_child(spawner)
	
	# Blocking off exits
	var dirs = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
	for i in dirs:
		var blockOff := preload("res://World/Props/DoorBlock/DoorBlock.tscn").instance()
		var collisionShape := RectangleShape2D.new()
		
		var extents:Vector2 = solids.get_used_rect().end
		#et_free_spot(startPos:Vector2, endPos:Vector2, incDir:Vector2) -> Dictionary:
		match i:
			Vector2.UP:
				var collisionSize = (extents.x*.5)*solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)
				
				blockOff.scale.x = -1
				blockOff.rotation_degrees = 90
				blockOff.position = Vector2((extents.x*.5), 0)
			Vector2.DOWN:
				var collisionSize = (extents.x*.5)*solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)
				
				blockOff.rotation_degrees = 90
				blockOff.position = Vector2((extents.x*.5), extents.y)
			Vector2.RIGHT:
				var collisionSize = (extents.y*.5)*solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)
				
				blockOff.position = Vector2(extents.x, (extents.y*.5))
			Vector2.LEFT:
				var collisionSize = (extents.y*.5)*solids.cell_size.x
				collisionShape.extents = Vector2(5, collisionSize)
				
				blockOff.scale.x = -1
				blockOff.position = Vector2(0, (extents.y*.5))
		
		add_child(blockOff)
		blockOff.position *= solids.cell_size
		blockOff.position = blockOff.position.round()
		blockOff.collision.shape = collisionShape
		blockOff.position_sprite()
		
		exitBlockers.append(blockOff)
	
	var roomSize = solids.get_used_rect().end
	create_loading_zone(Vector2(-24/16, roomSize.y*.5)*16, Vector2(32/16, roomSize.y*.5)*16, Vector2.LEFT) # Left
	create_loading_zone(Vector2(roomSize.x+(24/16), roomSize.y*.5)*16, Vector2(32/16, roomSize.y*.5)*16, Vector2.RIGHT) # Right
	create_loading_zone(Vector2(roomSize.x*.5, -24/16)*16, Vector2(roomSize.x*.5, 32/16)*16, Vector2.UP) # Up
	create_loading_zone(Vector2(roomSize.x*.5, roomSize.y+(24/16))*16, Vector2(roomSize.x*.5, 32/16)*16, Vector2.DOWN) # Down
	
	# Setting camera limits
	var camMoveShape = mainCamMove.collisionShape.shape.duplicate()
	var limits = solids.get_used_rect()

	limits.position = solids.map_to_world(limits.position)
	limits.end = solids.map_to_world(limits.end)
	
	var offset:Vector2 = get_viewport_rect().end-limits.end
	offset.x = clamp(offset.x, 0, INF); offset.y = clamp(offset.y, 0, INF)
	
	limits.end.x = clamp(limits.end.x, get_viewport_rect().end.x, INF)
	limits.end.y = clamp(limits.end.y, get_viewport_rect().end.y, INF)
	
	mainCamMove.position = (limits.end*.5).abs()
	mainCamMove.position -= offset*.5
	camMoveShape.extents = (limits.end*.5).abs()
	
	mainCamMove.collisionShape.shape = camMoveShape
	
	set_player_pos()
	
	# PADDING
	
	# Left padding
	pad(Vector2(0, -PADDING), Vector2(0, roomSize.y+PADDING), Vector2.DOWN, Vector2.LEFT)
	# Right padding
	pad(Vector2(roomSize.x-1, -PADDING), Vector2(roomSize.x-1, roomSize.y+PADDING), Vector2.DOWN, Vector2.RIGHT)
	# Up padding
	pad(Vector2(-PADDING, 0), Vector2(roomSize.x+PADDING, 0), Vector2.RIGHT, Vector2.UP)
	# Down padding
	pad(Vector2(-PADDING, roomSize.y-1), Vector2(roomSize.x+PADDING, roomSize.y-1), Vector2.RIGHT, Vector2.DOWN)

	if worldData.rooms[worldData.position.x-worldData.moveDir.x]\
	[worldData.position.y-worldData.moveDir.y].biome != biome\
	or worldData.moveDir == Vector2.ZERO:
		var newBiomeTitle = preload("res://UI/BiomeTitle/BiomeTitle.tscn").instance()
		canvasLayer.add_child(newBiomeTitle)
		newBiomeTitle.get_node("Title/Name").text = "The "+biome.name
	
	var timer = get_tree().create_timer(2.9)
	timer.connect("timeout", self, "_on_index_timer_timeout")
# 2.8s

func _on_index_timer_timeout() -> void:
	roomClearer.get_enemies()


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	GameManager.spawnManager.add_item(gun)


func add_props(propArr:Array, x, y):
	propArr.shuffle()
	var prop = propArr.front().instance()
	prop.position = Vector2(x, y)*solids.cell_size
	prop.position.x += solids.cell_size.x*.5
	props.add_child(prop)


func pad(startPos:Vector2, endPos:Vector2, incDir:Vector2, padDir:Vector2):
	var pos = startPos
	
	while pos != endPos:
		if solids.get_cellv(pos) > -1:
			for i in PADDING:
				var updatePos:Vector2 = pos+(padDir*i)
				solids.set_cellv(updatePos, 0)
				solids.update_bitmask_area(updatePos)
		pos += incDir


func set_player_pos():
	var size = solids.get_used_rect().end
	match worldData.moveDir:
		Vector2.RIGHT:
			var ppos = get_free_spot(Vector2.ZERO, Vector2(0, size.y), Vector2.DOWN).end
			ppos.x += 1.8
			player.position = ppos*solids.cell_size
			player.position.y -= 8
		Vector2.LEFT:
			var ppos = get_free_spot(Vector2(size.x-1, 0), Vector2(size.x-1, size.y), Vector2.DOWN).end
			ppos.x -= 1.8
			player.position = ppos*solids.cell_size
			player.position.y -= 8
		Vector2.UP:
			var positions = get_free_spot(Vector2(0, size.y-1), Vector2(size.x, size.y-1), Vector2.RIGHT)
			var x = (positions.end.x-positions.start.x)*.5
			var ppos = Vector2(positions.start.x+x, size.y-2)
			player.position = ppos*solids.cell_size
			player.vel.y = -player.playerData.jumpForce
		Vector2.DOWN:
			var positions = get_free_spot(Vector2.ZERO, Vector2(size.x, 0), Vector2.RIGHT)
			var x = (positions.end.x-positions.start.x)*.5
			var ppos = Vector2(positions.start.x+x, 2)
			player.position = ppos*solids.cell_size
	while solids.get_cellv(solids.world_to_map(player.position)) != -1:
		player.position.y -= solids.cell_size.y


func get_free_spot(startPos:Vector2, endPos:Vector2, incDir:Vector2) -> Dictionary:
	var firstUpdatedPos := startPos
	var lastUpdatedPos := startPos
	var updateCount = 0
	var i := startPos
	
	while i != endPos:
		if solids.get_cellv(i) == -1:
			if updateCount == 0: firstUpdatedPos = i
			lastUpdatedPos = i
			updateCount += 1
		i += incDir
	
	return {
		"start" : firstUpdatedPos,
		"end" : lastUpdatedPos
	}


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
	area.connect("area_entered", self, "_on_load_area", [direction])


func _on_load_area(area: Area2D, direction: Vector2) -> void:
	if !area.is_in_group("player"):
		return
	if player.playerData.isDead:
		return
	var timer = Timer.new()
	timer.wait_time = .4
	timer.connect("timeout", get_tree(), "reload_current_scene")
	add_child(timer)
	timer.start()
	
	worldData.position += direction
	worldData.moveDir = direction

	screenTrans.out()


func _on_enemies_cleared() -> void:
	for eb in exitBlockers:
		eb.queue_free()

