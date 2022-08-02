extends Node2D

const PADDING := 20

onready var world := get_parent()

enum TILES { SURR=0, LEFT=1, UP=2, RIGHT=3, DOWN=4 }

var worldData = preload("res://World/WorldManagement/WorldData.tres")
var biome:WorldArea
var room:Node

var width: int
var height: int

var brokenTiles = {}


func _ready() -> void:
	var _discard = connect("tree_exiting", self, "_on_tree_exiting")
func _on_tree_exiting() -> void:
	if room: room.queue_free()

func create_room() -> void:
	AudioServer.set_bus_effect_enabled(4, 0, true)
	
	if !worldData.get_current_room().has("seed"):
		randomize()
		worldData.get_current_room()["seed"] = randi()
	seed(worldData.get_current_room().seed)
	
	for t in world.tilesContainer.get_children():
		t.queue_free()
	biome = worldData.get_biome_by_index(worldData.rooms\
		[worldData.position.x][worldData.position.y].biome)

	MusicManager.set_music(biome.music)

	# Adding in the nodes

	world.solids = biome.solids.instance()
	world.solids.position = Vector2.ZERO
	world.solids.z_index = 1
	world.solids.light_mask = 0
	world.tilesContainer.add_child(world.solids)

	for i in worldData.get_connected_rooms(worldData.position):
		var currentRoom = worldData.rooms[worldData.position.x + i.x][worldData.position.y + i.y]
		if currentRoom.secret:
			var dir: Vector2 = i
			var key: int
			match dir:
				Vector2.LEFT:  key = TILES.LEFT
				Vector2.UP:    key = TILES.UP
				Vector2.RIGHT: key = TILES.RIGHT
				Vector2.DOWN:  key = TILES.DOWN
			var tiles = biome.brokenWall.instance()
			world.solids.add_child(tiles)
			brokenTiles[key] = tiles

	world.platforms = biome.platforms.instance()
	world.platforms.position = Vector2.ZERO
	world.platforms.z_index = 0
	world.tilesContainer.add_child(world.platforms)

	world.background = biome.background.instance()
	world.background.position = Vector2(8, 8)
	world.background.z_index = -3
	world.tilesContainer.add_child(world.background)

	world.darkness.color = Color(biome.brightness, biome.brightness, biome.brightness)
	var mod := 1.1 if Settings.gfx == Settings.GFX_BAD else 1.0
	world.darkness.color.r *= mod
	world.darkness.color.g *= mod
	world.darkness.color.b *= mod

	world.solidColorBG.color = biome.bgColor

	if biome.atmosphere:
		world.add_child(biome.atmosphere.instance())

	# Setup
	var connections:Array = worldData.get_connected_rooms(worldData.position)

	worldData.rooms[worldData.position.x][worldData.position.y].discovered = true
	for i in worldData.get_connected_rooms(worldData.position):
		worldData.rooms[worldData.position.x+i.x][worldData.position.y+i.y].nearDiscovered = true

	var cr = worldData.rooms[worldData.position.x][worldData.position.y].constantRoom
	if cr:
		var _cr = load(cr)

		room = _cr.scene.instance()
		if _cr.biomeSpecific.size() != 0:
			var idx = _cr.biomes.find(biome)
			room.queue_free()
			room = _cr.biomeSpecific[idx].instance()
		create_constant_room(connections)
	else:
		room = load(biome.roomTemplates + "Room%s.tscn" % [ceil(rand_range(0, biome.roomCount))]).instance()
		create_constant_room(connections)
		width = world.solids.get_used_rect().end.x
		height = world.solids.get_used_rect().end.y
		spawn_enemies()

	var roomSize = world.solids.get_used_rect().end
	create_loading_zone(Vector2(-32/16, roomSize.y*.5)*16, Vector2(32/16, roomSize.y*.5)*16, Vector2.LEFT) # Left
	create_loading_zone(Vector2(roomSize.x+(32/16), roomSize.y*.5)*16, Vector2(32/16, roomSize.y*.5)*16, Vector2.RIGHT) # Right
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

	yield(TempTimer.idle_frame(self, 2), "timeout")
	# PADDING
	pad(Vector2(0, -PADDING), Vector2(0, roomSize.y+PADDING), Vector2.DOWN, Vector2.LEFT)
	pad(Vector2(roomSize.x-1, -PADDING), Vector2(roomSize.x-1, roomSize.y+PADDING), Vector2.DOWN, Vector2.RIGHT)
	pad(Vector2(-PADDING, 0), Vector2(roomSize.x+PADDING, 0), Vector2.RIGHT, Vector2.UP)
	pad(Vector2(-PADDING, roomSize.y-1), Vector2(roomSize.x+PADDING, roomSize.y-1), Vector2.RIGHT, Vector2.DOWN)

	if worldData.get_biome_by_index(
	worldData.rooms[worldData.position.x-worldData.moveDir.x]\
	[worldData.position.y-worldData.moveDir.y].biome) != biome\
	or worldData.moveDir == Vector2.ZERO:
		var newBiomeTitle = preload("res://UI/BiomeTitle/BiomeTitle.tscn").instance()
		world.canvasLayer.add_child(newBiomeTitle)
		newBiomeTitle.get_node("Title/Name").text = tr(biome.name)

	for i in brokenTiles.keys():
		var tileset = brokenTiles[i]
		var startPos: Vector2
		var endPos: Vector2
		var incDir: Vector2
		var wallDir: Vector2
		var cell := 0
		match i:
			TILES.UP:
				startPos = Vector2.ZERO
				endPos = Vector2(roomSize.x, 0)
				incDir = Vector2.RIGHT
				wallDir = Vector2.UP
				cell = TILES.DOWN
			TILES.LEFT:
				startPos = Vector2.ZERO
				endPos = Vector2(0, roomSize.y)
				incDir = Vector2.DOWN
				wallDir = Vector2.LEFT
				cell = TILES.RIGHT
			TILES.RIGHT:
				startPos = Vector2(roomSize.x-1, 0)
				endPos = roomSize-Vector2.ONE
				incDir = Vector2.DOWN
				wallDir = Vector2.RIGHT
				cell = TILES.LEFT
			TILES.DOWN:
				startPos = Vector2(0, roomSize.y-1)
				endPos = roomSize-Vector2.ONE
				incDir = Vector2.RIGHT
				wallDir = Vector2.DOWN
				cell = TILES.UP
		var place = get_free_spot(startPos, endPos, incDir).start
		var timesLeft = 2
		while timesLeft != 0:
			var realPlace = place - incDir
			if world.solids.get_cellv(realPlace) == -1: tileset.set_cellv(realPlace, cell)
			for j in 20:
				var pos = realPlace + (wallDir * (j + 1))
				tileset.set_cellv(pos, 0)
				tileset.set_cellv(pos - incDir, 0)
				tileset.set_cellv(pos + incDir, 0)
			place += incDir
			if world.solids.get_cellv(place) != -1:
				timesLeft -= 1

			var pos = realPlace

			var isTiled1 = world.solids.get_cellv(pos) != -1
			var isTiled2 = world.solids.get_cellv(pos + wallDir) != -1

			world.solids.set_cellv(pos, 0)
			world.solids.set_cellv(pos + wallDir, 0)

			world.solids.update_bitmask_area(pos)

			if !isTiled1: world.solids.set_cellv(pos, -1)
			if !isTiled2: world.solids.set_cellv(pos + wallDir, -1)



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
		world.nonViableEnemySpawns.append(i)
		for j in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
			world.nonViableEnemySpawns.append(i + j)
	roomS.queue_free()
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
	if biome.decorator.roofProps.size() > 0:
		for i in roomCeilProps.get_used_cells():
			add_props(biome.decorator.roofProps, biome.decorator.roofPropsChance, i.x, i.y)
	# Floor Props
	var roomFloorprops:TileMap = room.groundProp
	if biome.decorator.groundProps.size() > 0:
		for i in roomFloorprops.get_used_cells():
			add_props(biome.decorator.groundProps, biome.decorator.groundPropsChance, i.x, i.y+1)
	# Props
	var roomPr:Node2D = room.props
	for c in roomPr.get_children():
		roomPr.remove_child(c)
		if c.has_meta("set_under_root") and c.get_meta("set_under_root"):
			world.add_child(c)
		else:
			add_child(c)
	# Tiling over none connected rooms
	var size = world.solids.get_used_rect().end-Vector2.ONE
	var nonconnections = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
	for i in connections: nonconnections.erase(i)
	for i in nonconnections:
		match i:
			Vector2.UP:
				if worldData.rooms\
				[worldData.position.x]\
				[worldData.position.y].isStartingRoom:
					continue
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

	var body = StaticBody2D.new()
	body.global_position = area.global_position
	body.collision_layer = 32
	var col = CollisionShape2D.new()
	col.shape = shape
	body.add_child(col)
	GameManager.spawnManager.spawn_object(body)

func set_player_pos() -> void:
	var size = world.solids.get_used_rect().end
	match worldData.moveDir:
		Vector2.RIGHT:
			var ppos = get_free_spot(Vector2.ZERO, Vector2(0, size.y), Vector2.DOWN).end
			ppos.x += 1.8
			world.player.position = ppos*world.solids.cell_size
			world.player.position.y -= 0
		Vector2.LEFT:
			var ppos = get_free_spot(Vector2(size.x-1, 0), Vector2(size.x-1, size.y), Vector2.DOWN).end
			ppos.x -= 1.8
			world.player.position = ppos*world.solids.cell_size
			world.player.position.y -= 0
		Vector2.UP:
			var positions = get_free_spot(Vector2(0, size.y-1), Vector2(size.x, size.y-1), Vector2.RIGHT)
			var x = (positions.end.x-positions.start.x)*.5
			var ppos = Vector2(positions.start.x+x, size.y)
			world.player.position = ppos*world.solids.cell_size
			world.player.vel.y = -world.player.playerData.jumpForce
			if GameManager.underwater: world.player.vel.y /= 2
		Vector2.DOWN:
			var positions = get_free_spot(Vector2.ZERO, Vector2(size.x, 0), Vector2.RIGHT)
			var x = (positions.end.x-positions.start.x)*.5
			var ppos = Vector2(positions.start.x+x, 1)
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

func add_props(propArr:Array, chances:Array, x, y) -> void:
	var idx
	while true:
		idx = rand_range(0, propArr.size())
		if rand_range(0, 1) > chances[idx]: continue
		var prop = propArr[idx].instance()
		prop.position = Vector2(x, y)*world.solids.cell_size
		prop.position.x += world.solids.cell_size.x*.5
		prop.z_index = -2
		world.props.add_child(prop)
		break



func spawn_enemies() -> void:
	if worldData.get_current_room().cleared: return
	var enemyPool = biome.enemyPools[rand_range(0, biome.enemyPools.size())]
	
	var enemyCount = ceil(
		(width / Globals.TEMPLATE_SIZE) \
		* (height / Globals.TEMPLATE_SIZE)) * 2
	
	for i in enemyCount:
		var spawnPos: Vector2
		while true:
			spawnPos = Vector2(rand_range(1, width-1), rand_range(1, height-1))
			if !spawnPos.round() in world.nonViableEnemySpawns: break
		
		var spawner = preload("res://Entities/Effects/EnemySpawn.tscn").instance()
		spawner.position = spawnPos*world.solids.cell_size
		spawner.position.x += world.solids.cell_size.x*.5
		spawner.position.y = clamp(
			spawner.position.y,
			32,
			(world.solids.get_used_rect().end.y*16)-32
		)
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
