extends Node2D

var tiles:TileMap
var backgroundTiles:TileMap
var planet:Planet
onready var player = $Props/Player
onready var backgrounds = $Background
onready var camera = $Props/Player/Camera
onready var props = $Props
onready var atmosphere = $Atmosphere
onready var placementTiles = $Props/PlaceTiles
onready var worldManager = $WorldManager
onready var mistSpawner = $Props/Player/MistSpawner
onready var tilePlaceSFX = $TilePlaceSFX
onready var minimap = $Props/Player/CanvasLayer/Minimap

var worldData = preload("res://WorldGeneration/WorldManagement/WorldData.tres")
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
	generate_room()
	set_camera_limits()
	add_visual_stuff()


func _process(_delta):
	minimap.set_icon_pos(player.position)


func add_visual_stuff():
	atmosphere.color = planet.atmosphereColor
	if planet.amosphereParticles:
		var atmosphereParticles = planet.amosphereParticles.instance()
		player.add_child(atmosphereParticles)
	mistSpawner.color = planet.mistColor
	mistSpawner.player = player
	mistSpawner.strength = planet.mistStrength


func generate_room():
	var planets = [
		"Reg",
		"Fire",
		"Acid",
		"Water"
	]

	planet = load("res://WorldGeneration/Planets/%s.tres" % planets[GameManager.planet])

	var worldGenerator = WorldGenerator.new()
	var world = worldGenerator.generate_world(
																	  # NOISE
		load("res://WorldGeneration/Noise/HeightMap.tres").noise,     # Height
		load("res://WorldGeneration/Noise/HeightMap.tres").noise,     # Shifting
		load("res://WorldGeneration/Noise/CaveNoise.tres"),           # Caves
																	  # CURVES
		load("res://WorldGeneration/Curves/HeightSmoothing.tres"),    # Height
		load("res://WorldGeneration/Curves/OverHangeSmoothing.tres"), # Shifting
		load("res://WorldGeneration/Curves/CaveSize.tres"),           # Caves

		5,
		300,
		0,
		8
	)

	tiles = planet.solidTiles.instance()
	props.add_child(tiles)
	backgroundTiles = tiles.duplicate()
	backgroundTiles.collision_layer = 0
	backgroundTiles.modulate = Color.gray
	backgroundTiles.z_index = -1
	props.add_child(backgroundTiles)

	for x in world.size():
		for y in world[x].size():
			# Adding tiles
			if world[x][y] == 1:
				backgroundTiles.set_cell(x, y, 0)
				backgroundTiles.update_bitmask_area(Vector2(x, y))
				continue
			tiles.set_cell(x, y, world[x][y])
			tiles.update_bitmask_area(Vector2(x, y))
			backgroundTiles.set_cell(x, y, world[x][y])
			backgroundTiles.update_bitmask_area(Vector2(x, y))


func check_approx(color:Color, color2:Color):
	if color.r-color2.r < .05 and color.g-color2.g < .05 and color.b-color2.b < .05:
		return true
	return false


func set_camera_limits():
	var tileRect:Rect2 = tiles.get_used_rect()
	var cellSize = tiles.cell_size.x

	camera.limit_bottom      = (tileRect.end.y-1)*cellSize
	camera.limit_right       = (tileRect.end.x-1)*cellSize
	camera.limit_top    = (tileRect.position.y+1)*cellSize
	camera.limit_left   = (tileRect.position.x+1)*cellSize


func set_minimap(image:Image):
	# Cleaning up the image

	var enemyColor = Color("#a00c0c")
	var solidColor = Color("#000000")
	var emptyColor = Color("#ffffff")

	image.lock()

	for x in image.get_width():
		for y in image.get_height():
			var pixelColor = image.get_pixel(x, y)
			if pixelColor.is_equal_approx(enemyColor):
				image.set_pixel(x, y, emptyColor)
			elif pixelColor.is_equal_approx(solidColor):
				image.set_pixel(x, y, Color.transparent)

	# Creating the texture
	var mapTex = ImageTexture.new()
	mapTex.create_from_image(image)

	minimap.set_map(mapTex)


func _on_player_removeTile(mousePosition):
	tilePlaceSFX.play()
	tilePlaceSFX.global_position = mousePosition

	# Setting the tiles
	var mapMousePos = tiles.world_to_map(mousePosition)
	if tiles.get_cellv(mapMousePos) == -1\
	and placementTiles.get_cellv(mapMousePos) == -1\
	and mousePosition.distance_to(player.position) > 16:

		placementTiles.set_cellv(mapMousePos, 0)
		placementTiles.update_bitmask_area(mapMousePos)
		return
	# Removing the tiles
	tiles.set_cellv(mapMousePos, -1)
	tiles.update_bitmask_area(mapMousePos)
	placementTiles.set_cellv(mapMousePos, -1)
	placementTiles.update_bitmask_area(mapMousePos)


func _on_World_tree_entered():
	get_tree().current_scene = self
	name = "World"
	yield(get_tree(), "idle_frame")
	atmosphere.color = planet.atmosphereColor


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	props.add_child(gun)
