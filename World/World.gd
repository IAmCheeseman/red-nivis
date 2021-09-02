extends Node2D

var tiles:TileMap
var altTiles:Array
var backgroundTiles:TileMap
onready var player = $Props/Player
onready var camera = $Props/Camera
onready var props = $Props
onready var atmosphere = $Atmosphere
onready var mistSpawner = $Props/Player/MistSpawner
#onready var tilePlaceSFX = $TilePlaceSFX
#onready var enemySpawner = $Props/EnemySpawner
onready var worldGenerator = $WorldGeneration
onready var solids = $Props/Tiles/LabSolids
onready var mainCamMove = $Props/CameraZones/CameraMoveZone
onready var loadingZone = $LoadingZone
onready var screenTrans = $ScreenTransition

export var solidPath:NodePath
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
	if solidPath:
		solids = get_node(solidPath)
	
	var entranceSize = solids.map_to_world(solids.get_used_rect().position)
	entranceSize.x = 0
	
	worldGenerator.generate_world()
	worldGenerator.queue_free()
	
	# Setting camera limits
	var camMoveShape = mainCamMove.collisionShape.shape
	var limits = solids.get_used_rect()
	
	limits.position = solids.map_to_world(limits.position)
	limits.end = solids.map_to_world(limits.end)
	limits.end.x = get_viewport_rect().end.x
	
	mainCamMove.position = (limits.end*.5).abs()+entranceSize
	camMoveShape.extents = (limits.end*.5).abs()-entranceSize

	loadingZone.position.y = abs(limits.end.y)+(16*5)
	loadingZone.loadPath = "res://World/World%s.tscn" % str(zoneNumber+1)
	
#	camera.limits = limits


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	GameManager.spawnManager.add_item(gun)


func _on_load_rea() -> void:
	var timer = Timer.new()
	timer.wait_time = .4
	timer.connect("timeout", get_tree(), "change_scene", [loadingZone.loadPath])
	add_child(timer)
	timer.start()

	screenTrans.out()

