extends Node2D

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
	
	var roofProps := [preload("res://World/Props/Foliage/Vine/Vine.tscn")]
	
	var room := RoomGenerator.generate(worldData.position.x+worldData.position.y, "LabTemplates.png", 11, [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP])
	room.lock()
	for x in room.get_width():
		for y in room.get_height():
			var pixel := room.get_pixel(x, y)
			if pixel.is_equal_approx(RoomGenerator.TILE):
				solids.set_cell(x, y, 0)
				solids.update_bitmask_area(Vector2(x, y))
				
				if rand_range(0, 1) < .5 and room.get_pixel(x, clamp(y+1, 0, room.get_height()-1)).is_equal_approx(RoomGenerator.EMPTY):
					roofProps.shuffle()
					var prop = roofProps.front().instance()
					prop.position = Vector2(x, y)*solids.cell_size
					prop.position.y += solids.cell_size.y
					prop.position.x += round(rand_range(0, solids.cell_size.x))
					props.add_child(prop)
				
			elif pixel.is_equal_approx(RoomGenerator.PLATFORM):
				platforms.set_cell(x, y, 0)
				platforms.update_bitmask_area(Vector2(x, y))
	
	var roomSize = solids.get_used_rect().end
	create_loading_zone(Vector2(0, roomSize.y*.5)*16, Vector2(.5, roomSize.y*.5)*16, Vector2.LEFT) # Left
	create_loading_zone(Vector2(roomSize.x, roomSize.y*.5)*16, Vector2(.5, roomSize.y*.5)*16, Vector2.RIGHT) # Right
	create_loading_zone(Vector2(roomSize.x*.5, 0)*16, Vector2(roomSize.x*.5, .5)*16, Vector2.UP) # Up
	create_loading_zone(Vector2(roomSize.x*.5, roomSize.y)*16, Vector2(roomSize.x*.5, .5)*16, Vector2.DOWN) # Down
	
	# Setting camera limits
	var camMoveShape = mainCamMove.collisionShape.shape
	var limits = solids.get_used_rect()

	limits.position = solids.map_to_world(limits.position)
	limits.end = solids.map_to_world(limits.end)
	limits.end.x = clamp(limits.end.x, get_viewport_rect().end.x, INF)
	limits.end.y = clamp(limits.end.y, get_viewport_rect().end.y, INF)

	mainCamMove.position = (limits.end*.5).abs()
	camMoveShape.extents = (limits.end*.5).abs()
	
	mainCamMove.collisionShape.shape = camMoveShape


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	GameManager.spawnManager.add_item(gun)


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
	var timer = Timer.new()
	timer.wait_time = .4
	timer.connect("timeout", get_tree(), "reload_current_scene")
	add_child(timer)
	timer.start()
	
	worldData.position += direction

	screenTrans.out()

