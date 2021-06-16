extends Node2D

var tiles
var backgroundTiles
var shadows
var planet:Planet
onready var background = $BackgroundHelper/BackGround
onready var player = $Props/Player
onready var camera = $Props/Player/Camera
onready var props = $Props
onready var atmosphere = $Atmosphere
onready var placementTiles = $Props/PlaceTiles
onready var playerShip = $Props/Ship
onready var mistSpawner = $Props/Player/MistSpawner
onready var tilePlaceSFX = $TilePlaceSFX
onready var minimap = $Minimap/Minimap

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

	playerShip.position = player.position


func _process(_delta):
	minimap.set_icon_pos(player.position)


func add_visual_stuff():
	atmosphere.color = planet.atmosphereColor
	if planet.amosphereParticles:
		var atmosphereParticles = planet.amosphereParticles.instance()
		player.add_child(atmosphereParticles)
	else:
		print("NO AMBIENT PARTICLES DEFINED FOR PLANET")
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

	# Getting the room image
	var worldGenerater = WorldGenerator.new()
	var world:Image = worldGenerater.generate_room(planet)
	worldGenerater.queue_free()

	world.lock()

	# Setting up the tiles & enemies

	var enemyColor = Color("#a00c0c")
	var solidColor = Color("#000000")

	tiles = planet.solidTiles.instance()
	props.add_child(tiles)

	for x in world.get_width():
		for y in world.get_height():
			if world.get_pixel(x, y).is_equal_approx(solidColor):
				tiles.set_cell(x, y, 0)
				tiles.update_bitmask_area(Vector2(x, y))
			elif world.get_pixel(x, y).is_equal_approx(enemyColor):
				var enemies = planet.enemies
				var enemyChances = planet.enemyChances
				if enemies.size() > 0:
					var selectedEnemy = rand_range(0, enemies.size())
					while rand_range(0, 100) > enemyChances[selectedEnemy]:
						selectedEnemy = rand_range(0, enemies.size())

					var enemy = enemies[selectedEnemy].instance()
					enemy.position = Vector2(x, y)*16
					enemy.set_player(player)
					props.add_child(enemy)

	# Adding an extra layer to the x axis
	for x in world.get_width():
		if tiles.get_cell(x, 0) != -1:
			tiles.set_cell(x, -1, 0)
			tiles.update_bitmask_area(Vector2(x, -1))
		if tiles.get_cell(x, world.get_height()-1) != -1:
			tiles.set_cell(x, world.get_height(), 0)
			tiles.update_bitmask_area(Vector2(x, world.get_height()))
	# Adding an extra layer to the y axis
	for y in world.get_height():
		if tiles.get_cell(0, y) != -1:
			tiles.set_cell(-1, y, 0)
			tiles.update_bitmask_area(Vector2(-1, y))
		if tiles.get_cell(world.get_width()-1, y) != -1:
			tiles.set_cell(world.get_width(), y, 0)
			tiles.update_bitmask_area(Vector2(world.get_width(), y))


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

	set_minimap(world)


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
				image.set_pixel(x, y, Color(1, 1, 1, 0))

	# Creating the texture
	var mapTex = ImageTexture.new()
	mapTex.create_from_image(image)

	minimap.set_map(mapTex)


func _on_player_removeTile(mousePosition):
	GameManager.emit_signal("screenshake", 0, 0, .1, .1, 5)
	tilePlaceSFX.play()
	tilePlaceSFX.global_position = mousePosition

	var mapMousePos = placementTiles.world_to_map(mousePosition)
	if tiles.get_cellv(mapMousePos) == -1\
	and placementTiles.get_cellv(mapMousePos) == -1\
	and mousePosition.distance_to(player.position) > 16:

		placementTiles.set_cellv(mapMousePos, 0)
		placementTiles.update_bitmask_area(mapMousePos)

		shadows.set_cellv(mapMousePos, 0)
		shadows.update_bitmask_area(mapMousePos)
		return

	tiles.set_cellv(mapMousePos, -1)
	tiles.update_bitmask_area(mapMousePos)
	placementTiles.set_cellv(mapMousePos, -1)
	placementTiles.update_bitmask_area(mapMousePos)
	shadows.set_cellv(mapMousePos, -1)
	shadows.update_bitmask_area(mapMousePos)


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
