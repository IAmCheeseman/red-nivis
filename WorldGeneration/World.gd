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

	# Getting the room image
	var world:Image
	var worldPos = worldManager.worldData.position
	var roomImage = worldManager.worldData.rooms[worldPos.y][worldPos.x].layout
	if !roomImage:
		var worldGenerator = WorldGenerator.new()
		worldManager.worldData.rooms[worldPos.y][worldPos.x].layout = worldGenerator.generate_room(planet)
	roomImage = worldManager.worldData.rooms[worldPos.y][worldPos.x].layout
	world = roomImage.duplicate()

	world.lock()

	# Setting up the tiles, enemies, & ruins

	var enemyColor = Color("#a00c0c")
	var solidColor = Color("#000000")
	var ruinColor  = Color("#44cb30")

	tiles = planet.solidTiles.instance()
	props.add_child(tiles)

	for x in world.get_width():
		for y in world.get_height():
			# Adding tiles
			if world.get_pixel(x, y).is_equal_approx(solidColor):
				tiles.set_cell(x, y, 0)
				tiles.update_bitmask_area(Vector2(x, y))
			# Enemies
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
			# Ruins
			elif check_approx(world.get_pixel(x, y),ruinColor):
				var ruinCount = 4
				var newRuin = load("res://Ruins/Human/WorldAppearance/BaseRuins%s.tscn" % int(rand_range(1, ruinCount+1))).instance()
				newRuin.position = Vector2(x, y)*16
				props.add_child(newRuin)

	var playerOutput = worldData.lastUpdatedDir

	# Placing the player and adding padding

	# Adding an extra layer to the x axis
	for x in world.get_width():
		if tiles.get_cell(x, 0) != -1:
			tiles.set_cell(x, -1, 0)
			tiles.update_bitmask_area(Vector2(x, -1))
		elif playerOutput == Vector2.DOWN:
			player.position = Vector2(x, 1)
		if tiles.get_cell(x, world.get_height()-1) != -1:
			tiles.set_cell(x, world.get_height(), 0)
			tiles.update_bitmask_area(Vector2(x, world.get_height()))
		elif playerOutput == Vector2.UP:
			player.position = Vector2(x, world.get_height()-1)
	# Adding an extra layer to the y axis
	for y in world.get_height():
		if tiles.get_cell(0, y) != -1:
			tiles.set_cell(-1, y, 0)
			tiles.update_bitmask_area(Vector2(-1, y))
		elif playerOutput == Vector2.RIGHT:
			player.position = Vector2(1, y)
		if tiles.get_cell(world.get_width()-1, y) != -1:
			tiles.set_cell(world.get_width(), y, 0)
			tiles.update_bitmask_area(Vector2(world.get_width(), y))
		elif playerOutput == Vector2.LEFT:
			player.position = Vector2(world.get_width()-1, y)
	player.position *= tiles.cell_size.x

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

	# Setting the exit areas

	# Left Exit Area
	var shape = RectangleShape2D.new()
# warning-ignore:integer_division
	shape.extents = Vector2(2, world.get_height()/2*16)
# warning-ignore:integer_division
	setExitArea(Vector2(0, world.get_height()/2), shape, Vector2.LEFT)
	# Right Exit Area
	shape = RectangleShape2D.new()
# warning-ignore:integer_division
	shape.extents = Vector2(2, world.get_height()/2*16)
# warning-ignore:integer_division
	setExitArea(Vector2(world.get_width(), world.get_height()/2), shape, Vector2.RIGHT)
	# Up Exit Area
	shape = RectangleShape2D.new()
# warning-ignore:integer_division
	shape.extents = Vector2(world.get_width()/2*16, 2)
# warning-ignore:integer_division
	setExitArea(Vector2(world.get_width()/2, 0), shape, Vector2.UP)
	# Down Exit Area
	shape = RectangleShape2D.new()
# warning-ignore:integer_division
	shape.extents = Vector2(world.get_width()/2*16, 2)
# warning-ignore:integer_division
	setExitArea(Vector2(world.get_width()/2, world.get_height()), shape, Vector2.DOWN)

	set_minimap(world)


func setExitArea(_position, shape, dir):
	var newExitArea = preload("res://WorldGeneration/ExitArea.tscn").instance()
	newExitArea.position = _position*16
	newExitArea.direction = dir
	add_child(newExitArea)
	newExitArea.set_collider(shape)
	newExitArea.connect("move_to_room", worldManager, "move_in_direction")


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
