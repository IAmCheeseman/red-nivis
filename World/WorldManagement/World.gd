extends Node2D

const PADDING = 20

var tiles:TileMap
var altTiles:Array
var backgroundTiles:TileMap
onready var player = $Props/Player
onready var props = $Props
onready var atmosphere = $Atmosphere
onready var mistSpawner = $Props/Player/MistSpawner
onready var solids = $Props/Tiles/LabSolids
onready var platforms = $Props/Tiles/OneWayPlatforms
onready var mainCamMove = $Props/CameraZones/CameraMoveZone
onready var screenTrans = $ScreenTransition

export var solidPath:NodePath
export var platformPath:NodePath
export var zoneNumber:int = 0

var worldData = preload("res://World/WorldManagement/WorldData.tres")


func _ready():
	AudioServer.set_bus_effect_enabled(4, 0, true)
	
	if solidPath:
		solids = get_node(solidPath)
	if platformPath:
		platforms = get_node(platformPath)
	
	var roofProps := [
		preload("res://World/Props/Foliage/Vine/Vine.tscn")
	]
	var groundProps := [
		preload("res://World/Props/Containers/Locker/Locker.tscn"),
		preload("res://World/Props/Containers/Safe/Safe.tscn")
	]
	var enemies := [
		preload("res://Entities/Enemies/MiniDeathMachine/MDM.tscn"),
		preload("res://Entities/Enemies/MinigunMachine/MinigunMachine.tscn")
	]
	
	var connections:Array = worldData.get_connected_rooms(worldData.position)
	var room := RoomGenerator.generate(worldData.position.x+worldData.position.y, "LabTemplates.png", 13, connections)
	
	var viableEnemySpawns = [] 
	
	room.lock()
	for x in room.get_width():
		for y in room.get_height():
			var pixel := room.get_pixel(x, y)
			if pixel.is_equal_approx(RoomGenerator.TILE):
				solids.set_cell(x, y, 0)
				solids.update_bitmask_area(Vector2(x, y))
				
# warning-ignore:narrowing_conversion
				if rand_range(0, 1) < .5 and room.get_pixel(x, clamp(y+1, 0, room.get_height()-1)).is_equal_approx(RoomGenerator.EMPTY):
					add_props(roofProps, x, y+1)
# warning-ignore:narrowing_conversion
				if rand_range(0, 1) < .1 and room.get_pixel(x, clamp(y-1, 0, room.get_height()-1)).is_equal_approx(RoomGenerator.EMPTY):
					add_props(groundProps, clamp(x, 2, room.get_width()-2), y)
			elif pixel.is_equal_approx(RoomGenerator.PLATFORM):
				platforms.set_cell(x, y, 0)
				platforms.update_bitmask_area(Vector2(x, y))
			if rand_range(0, 1) < Globals.ENEMY_SPAWN_CHANCE and room.get_pixel(x, y).is_equal_approx(RoomGenerator.EMPTY):
				viableEnemySpawns.append(Vector2(x, y))
	
	for i in Globals.MAX_ENEMIES:
		if viableEnemySpawns.size() == 0:
			break
		var spawnPos:Vector2 = viableEnemySpawns.pop_front()
		add_props(enemies, spawnPos.x, spawnPos.y)
	
	var roomSize = solids.get_used_rect().end
	create_loading_zone(Vector2(0, roomSize.y*.5)*16, Vector2(.5, roomSize.y*.5)*16, Vector2.LEFT) # Left
	create_loading_zone(Vector2(roomSize.x, roomSize.y*.5)*16, Vector2(.5, roomSize.y*.5)*16, Vector2.RIGHT) # Right
	create_loading_zone(Vector2(roomSize.x*.5, 0)*16, Vector2(roomSize.x*.5, .5)*16, Vector2.UP) # Up
	create_loading_zone(Vector2(roomSize.x*.5, roomSize.y)*16, Vector2(roomSize.x*.5, .5)*16, Vector2.DOWN) # Down
	
	
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


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	GameManager.spawnManager.add_item(gun)


func add_props(propArr:Array, x, y):
	propArr.shuffle()
	var prop = propArr.front().instance()
	prop.position = Vector2(x, y)*solids.cell_size
	prop.position.x += round(rand_range(0, solids.cell_size.x))
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
	area.position = pos
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
	var timer = Timer.new()
	timer.wait_time = .4
	timer.connect("timeout", get_tree(), "reload_current_scene")
	add_child(timer)
	timer.start()
	
	worldData.position += direction
	worldData.moveDir = direction

	screenTrans.out()

