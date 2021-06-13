extends Node2D

var tiles
var backgroundTiles
var shadows
var planet:Planet
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
#	worldGenerater.set_up(tiles, props, shadows, background, backgroundTiles, player)
	generate_room()
	maxEnemies = planet.maxEnemies
	atmosphere.color = planet.atmosphereColor
	if planet.amosphereParticles:
		var atmosphereParticles = planet.amosphereParticles.instance()
		player.add_child(atmosphereParticles)
	else:
		print("NO AMBIENT PARTICLES DEFINED FOR PLANET")
	playerShip.position = player.position
	mistSpawner.color = planet.mistColor
	mistSpawner.player = player
	mistSpawner.strength = planet.mistStrength


func generate_room():
	# Getting the room image
	var worldGenerater = WorldGenerator.new()
	var world:Image = worldGenerater.generate_room()
	worldGenerater.queue_free()
	world.lock()

	var planets = [
		"Reg",
		"Fire",
		"Acid",
		"Water"
	]

	planet = load("res://WorldGeneration/Planets/%s.tres" % planets[GameManager.planet])

	# Setting up the tiles
	var tiles = planet.solidTiles.instance()
	props.add_child(tiles)

	for x in world.get_width():
		for y in world.get_height():
			if world.get_pixel(x, y).is_equal_approx(Color(0, 0, 0)):
				tiles.set_cell(x, y, 0)
				tiles.update_bitmask_area(Vector2(x, y))
	# Shadows
	shadows = tiles.duplicate()
	shadows.position.y += 12
	shadows.modulate = Color(0, 0, 0, .5)
	shadows.show_behind_parent = true
	shadows.cell_y_sort = false
	shadows.collision_layer = 0

	tiles.add_child(shadows)

	# Setting the background
	background.rect_position = Vector2.ONE*-20000
	background.rect_size = Vector2(10000, 10000)*3
	background.texture = planet.backgroundImage



func _on_player_removeTile(mousePosition):
	pass
#	GameManager.emit_signal("screenshake", 0, 0, .1, .1, 5)
#	tilePlaceSFX.play()
#	tilePlaceSFX.global_position = mousePosition
#
#	var mapMousePos = placementTiles.world_to_map(mousePosition)
#	if tiles.get_cellv(mapMousePos) == -1\
#	and placementTiles.get_cellv(mapMousePos) == -1\
#	and mousePosition.distance_to(player.position) > 16:
#
#		placementTiles.set_cellv(mapMousePos, 0)
#		placementTiles.update_bitmask_area(mapMousePos)
#
#		shadows.set_cellv(mapMousePos, 0)
#		shadows.update_bitmask_area(mapMousePos)
#		return
#	placementTiles.set_cellv(mapMousePos, -1)
#	placementTiles.update_bitmask_area(mapMousePos)
#	tiles.set_cellv(mapMousePos, -1)
#	tiles.update_bitmask_area(mapMousePos)
#	shadows.set_cellv(mapMousePos, -1)
#	shadows.update_bitmask_area(mapMousePos)
##	minedTiles.append(mapMousePos)
#	var maxMineStorage = 1048576
#	if var2bytes(worldGenerater.minedTiles).size() > maxMineStorage:
#		worldGenerater.minedTiles.pop_front()


func _on_World_tree_entered():
	get_tree().current_scene = self
	name = "World"
	yield(get_tree(), "idle_frame")
#	atmosphere.color = GameManager.planet.atmosphereColor


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	gun.turn_to_pick_up()
	props.add_child(gun)
