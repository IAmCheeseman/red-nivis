extends Node2D

var tiles:TileMap
var backgroundTiles:TileMap
var planet:Planet
onready var player = $Props/Player
onready var backgrounds = $Background
onready var sky = $Sky/Sky
onready var camera = $Props/Player/Camera
onready var props = $Props
onready var atmosphere = $Atmosphere
onready var placementTiles = $Props/PlaceTiles
onready var mistSpawner = $Props/Player/MistSpawner
onready var tilePlaceSFX = $TilePlaceSFX
onready var minimap = $Props/Player/CanvasLayer/Minimap
onready var enemySpawner = $Props/EnemySpawner

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
	generate_world()
	set_camera_limits()
	add_visual_stuff()
	enemySpawner.tiles = tiles


func _process(_delta):
	minimap.set_icon_pos(player.position)


func add_visual_stuff():
	atmosphere.color = planet.atmosphereColor
	# Atmosphere particles
	if planet.atmosphereParticles:
		var atmosphereParticles = planet.amosphereParticles.instance()
		player.add_child(atmosphereParticles)
	# Mist
	mistSpawner.color = planet.mistColor
	mistSpawner.player = player
	mistSpawner.strength = planet.mistStrength
	# Backgrounds
	sky.texture = planet.sky
	for p in planet.backgroundImages.size():
		var newImage = Sprite.new()
		newImage.centered = false
		newImage.offset.y = -50
		newImage.texture = planet.backgroundImages[p]
		newImage.region_enabled = true
		newImage.region_rect = Rect2(0, 0, 8325670, 350)
		backgrounds.get_child(p).add_child(newImage)



func generate_world():
	var planets = [
		"Reg",
		"Fire",
		"Acid",
		"Water"
	]

	planet = load("res://World/Planets/%s.tres" % planets[GameManager.planet])

	GameManager.gravity = planet.gravity
	var worldSize = Vector2(20, 10)
	var worldGenerator = WorldGenerator.new()
	var world = worldGenerator.generate_world(
		worldSize,
		5*16,
		preload("res://World/Noise/HeightMap.tres").noise,
		load(planet.flatTemplates).get_data(),
		load(planet.connectionTemplates).get_data()
		)

	tiles = planet.solidTiles.instance()
	props.add_child(tiles)
	backgroundTiles = tiles.duplicate()
	backgroundTiles.collision_layer = 0
	backgroundTiles.modulate = Color.gray
	backgroundTiles.z_index = -1
	props.add_child(backgroundTiles)

	var solidColor := Color("#000000")
	var wallColor := Color("#34315b")

	world.lock()
	for x in world.get_width():
		for y in world.get_height():
			if world.get_pixel(x, y).is_equal_approx(solidColor):
				tiles.set_cell(x, y, 0)
				backgroundTiles.set_cell(x, y, 0)
				tiles.update_bitmask_area(Vector2(x, y))
				backgroundTiles.update_bitmask_area(Vector2(x, y))
			if world.get_pixel(x, y).is_equal_approx(wallColor):
				backgroundTiles.set_cell(x, y, 0)
				backgroundTiles.update_bitmask_area(Vector2(x, y))
	generate_ruins(worldSize*16, 5)


func generate_ruins(worldSize:Vector2, ruinCount:int=5) -> void:
	var ruinRects = []
	for r in ruinCount:
		var newRuinPos = Vector2.ZERO
		var maxAttempts = 500
		var attempts = 0
		var isOverlapping = false
		# Making sure it's generating on the ground
		while (tiles.get_cellv(newRuinPos) == -1 or tiles.get_cellv(newRuinPos+Vector2.UP) != -1)\
			or isOverlapping:
			newRuinPos.x = rand_range(0, worldSize.x)
			newRuinPos.y = rand_range(0, worldSize.y)
			newRuinPos = newRuinPos.snapped(Vector2(1, 1))
			attempts += 1
			for rect in ruinRects:
				isOverlapping = rect.has_point(newRuinPos)
				if isOverlapping: break

			if attempts == maxAttempts: break
		if attempts == maxAttempts: continue

		# If everything goes well
		var newRuin = load("res://World/Ruins/Layouts/Ruin%s.tscn" % round(rand_range(1, 2))).instance()
		newRuin.position = newRuinPos*16
		newRuin.show_behind_parent = true
		props.add_child(newRuin)
		# Removing any overlapping tiles
		for i in newRuin.tiles.get_used_cells():
			tiles.set_cellv(newRuinPos+i, -1)
			tiles.update_bitmask_area(newRuinPos+i)
		for i in newRuin.fgProps.get_used_cells():
			if tiles.get_cellv(newRuinPos+i) != -1:
				newRuin.fgProps.set_cellv(i, -1)

		var ruinRect = newRuin.tiles.get_used_rect()
		ruinRect.position = newRuinPos
		ruinRects.append(ruinRect)


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
	camera.limit_top -= 200*cellSize


func _on_player_removeTile(mousePosition):
	tilePlaceSFX.play()
	tilePlaceSFX.global_position = mousePosition
	Cursor.get_node("Sprite").scale = Vector2(.8, .8)

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
