extends Node2D

var tiles:TileMap
var altTiles:Array
var backgroundTiles:TileMap
onready var player = $Props/Player
onready var camera = $Props/Player/Camera
onready var props = $Props
onready var atmosphere = $Atmosphere
onready var mistSpawner = $Props/Player/MistSpawner
onready var tilePlaceSFX = $TilePlaceSFX
#onready var enemySpawner = $Props/EnemySpawner
onready var worldGenerator = $WorldGeneration
onready var solids = $Props/Tiles/LabSolids

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
	worldGenerator.generate_world()
	worldGenerator.queue_free()
	
	print(solids.tile_set.get_tiles_ids())
	
	# Setting camera limits
	var limits = solids.get_used_rect()
	
	limits.position.x += 1
	limits.end.x -= 1
	
	limits.position *= solids.cell_size.x
	limits.end *= solids.cell_size.x

	var centering = abs(get_viewport_rect().end.x-limits.end.x)
	limits.position.x += centering*.15
	limits.end.x -= centering
	
	camera.limit_left = limits.position.x
	camera.limit_right = limits.end.x


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	GameManager.spawnManager.add_item(gun)
