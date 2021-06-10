extends Node2D

var tiles
var backgroundTiles
var shadows
onready var background = $BackgroundHelper/BackGround
onready var player = $Props/Player
onready var camera = $Props/Player/Camera
onready var props = $Props
onready var worldGenerater = $WorldGeneration
onready var atmosphere = $Atmosphere
onready var placementTiles = $Props/PlaceTiles
onready var playerShip = $Props/Ship
onready var mistSpawner = $Props/Player/MistSpawner
onready var tilePlaceSFX = $TilePlaceSFX

var queuedChunks : Array
var queueFreeChunks : Array
var generatedChunks : Array
var ruinedChunks : Array
var propedChunks : Array
var lastChunk = Vector2.ZERO
var chunkAmount = 3
var firstTime = true
var maxEnemies
var enemyCount = 0


func _ready():
	worldGenerater.set_up(tiles, props, shadows, background, backgroundTiles, player)
	maxEnemies = worldGenerater.planet.maxEnemies
	atmosphere.color = worldGenerater.planet.atmosphereColor
	if worldGenerater.planet.amosphereParticles:
		var atmosphereParticles = worldGenerater.planet.amosphereParticles.instance()
		player.add_child(atmosphereParticles)
	else:
		print("NO AMBIENT PARTICLES DEFINED FOR PLANET")
	playerShip.position = player.position
	mistSpawner.color = worldGenerater.planet.mistColor
	mistSpawner.player = player
	mistSpawner.strength = worldGenerater.planet.mistStrength



func _on_player_removeTile(mousePosition):
	GameManager.emit_signal("screenshake", 0, 0, .1, .1, 5)
	tilePlaceSFX.play()
	tilePlaceSFX.global_position = mousePosition

	var mapMousePos = worldGenerater.tiles.world_to_map(mousePosition)
	if worldGenerater.tiles.get_cellv(mapMousePos) == -1\
	and placementTiles.get_cellv(mapMousePos) == -1\
	and mousePosition.distance_to(player.position) > 16:

		placementTiles.set_cellv(mapMousePos, 0)
		placementTiles.update_bitmask_area(mapMousePos)

		worldGenerater.shadows.set_cellv(mapMousePos, 0)
		worldGenerater.shadows.update_bitmask_area(mapMousePos)
		return
	placementTiles.set_cellv(mapMousePos, -1)
	placementTiles.update_bitmask_area(mapMousePos)
	worldGenerater.tiles.set_cellv(mapMousePos, -1)
	worldGenerater.tiles.update_bitmask_area(mapMousePos)
	worldGenerater.shadows.set_cellv(mapMousePos, -1)
	worldGenerater.shadows.update_bitmask_area(mapMousePos)
	worldGenerater.minedTiles.append(mapMousePos)
	var maxMineStorage = 1048576
	if var2bytes(worldGenerater.minedTiles).size() > maxMineStorage:
		worldGenerater.minedTiles.pop_front()


func _on_World_tree_entered():
	get_tree().current_scene = self
	name = "World"
	yield(get_tree(), "idle_frame")
	atmosphere.color = GameManager.planet.atmosphereColor


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	gun.turn_to_pick_up()
	props.add_child(gun)
