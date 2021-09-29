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

var queuedChunks : Array
var queueFreeChunks : Array
var generatedChunks : Array
var ruinedChunks : Array
var propedChunks : Array
var lastChunk = Vector2.ZERO
var chunkAmount = 3
var firstTime = true
var enemyCount = 0


func _ready():
	AudioServer.set_bus_effect_enabled(4, 0, true)
	
	if solidPath:
		solids = get_node(solidPath)
	if platformPath:
		platforms = get_node(platformPath)
	
	var roofProps := [preload("res://World/Props/Foliage/Vine/Vine.tscn")]
	
	var room := RoomGenerator.generate(randi(), "LabTemplates.png", 11)
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
					prop.position.x += solids.cell_size.x*.5
					props.add_child(prop)
				
			elif pixel.is_equal_approx(RoomGenerator.PLATFORM):
				platforms.set_cell(x, y, 0)
				platforms.update_bitmask_area(Vector2(x, y))

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


#func _on_load_rea() -> void:
#	var timer = Timer.new()
#	timer.wait_time = .4
#	timer.connect("timeout", get_tree(), "change_scene", [loadingZone.loadPath])
#	add_child(timer)
#	timer.start()
#
#	screenTrans.out()

