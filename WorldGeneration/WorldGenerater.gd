extends Node

var tiles
var props
var amountOfRuins
var shadows
var background
var backgroundTiles
var player
var planet
var solidNoise

var worldSeed = 0

var queuedLoadChunks = []
var queuedFreeChunks = []

var minibiomeSolids = []

var minedTiles = []

var ruinCount = 0
var maxRuinCount = 4
var ruinRange = 16*31
var minRuinDist = 16*21

var thread = Thread.new()


func _process(_delta):
	if queuedLoadChunks.size() > 0:
		thread.start(self, "generate_chunk")


# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func set_up(tiles, props, shadows, background, backgroundTiles, player):
	self.tiles = tiles
	self.props = props
	self.shadows = shadows
	self.background = background
	self.backgroundTiles = backgroundTiles
	self.player = player
	node_set_up()


func node_set_up():
	randomize()
	worldSeed = randi()
	var planets = [
		preload("res://WorldGeneration/Planets/Reg.tres"),
		preload("res://WorldGeneration/Planets/Fire.tres"),
		preload("res://WorldGeneration/Planets/Acid.tres"),
		preload("res://WorldGeneration/Planets/Water.tres")
	]

	planet = planets[GameManager.planet]
	GameManager.planet = planet

	background.rect_position = Vector2.ONE*-20000
	background.rect_size = Vector2(10000, 10000)*3
	background.texture = planet.backgroundImage

	tiles = planet.solidTiles.instance()
	shadows = tiles.duplicate()
	shadows.position.y += 12
	shadows.modulate = Color(0, 0, 0, .5)
	shadows.show_behind_parent = true
	shadows.cell_y_sort = false
	shadows.collision_layer = 0
	tiles.add_child(shadows)

	props.add_child(tiles)
	if planet.backgroundTiles != null:
		backgroundTiles = planet.backgroundTiles.instance()
		props.add_child(backgroundTiles)

	solidNoise = planet.noiseTexture.noise
	solidNoise.seed = worldSeed

	if planet.miniBiomes.size() > 0:
		for i in planet.miniBiomes:
			var solids = i.mainTiles.instance()
			props.add_child(solids)
			minibiomeSolids.append(solids)


	while solidNoise.get_noise_2d(tiles.world_to_map(player.position).x, 0) < planet.minNoise:
		player.position.x += 16
		player.position.y = 0



func add_human_ruin():
	if ruinCount > maxRuinCount: return

	var selectedDir = Vector2.RIGHT.rotated(deg2rad(rand_range(0, 360)))
	var selectedDist = rand_range(minRuinDist, ruinRange)
	var ruinPosition = (selectedDir*selectedDist+player.position).round()

	if tiles.get_cellv(tiles.world_to_map(ruinPosition)) != -1:
		return

	var ruinHandler = RuinHandler.new()
	var ruins = ruinHandler.get_ruins(true)
	ruins.shuffle()
	var ruin = ruins[0].instance()
	ruin.position = ruinPosition
	ruin.worldGenerator = self
	props.add_child(ruin)
	ruin.set_color(planet.ruinColor)

	ruinCount += 1


func generate_chunk(chunkx, chunky):
	# WORLD GENERATION
	# --------------------------------------------------------
	# Setting Solids
	# -------------------------------------------

	# Noise Gen
	for x in planet.chunkSize:
		for y in planet.chunkSize:
			if solidNoise.get_noise_2d(chunkx+x, chunky+y) < planet.minNoise\
			and !Vector2(chunkx+x, chunky+y) in minedTiles:
				tiles.set_cell(chunkx+x, chunky+y, 0)
				shadows.set_cell(chunkx+x, chunky+y, 0)
				tiles.update_bitmask_area(Vector2(chunkx+x, chunky+y))
				shadows.update_bitmask_area(Vector2(chunkx+x, chunky+y))
#	yield(get_tree(), "idle_frame")
	#--------------------------------------------

	# Background
	# -------------------------------------------

	if planet.backgroundTiles:
		var altBGNoise = OpenSimplexNoise.new()
		altBGNoise.octaves = 9
		altBGNoise.period = 21.1
		altBGNoise.persistence = 0
		altBGNoise.lacunarity = .1
		for x in planet.chunkSize:
			for y in planet.chunkSize:
				if altBGNoise.get_noise_2d(chunkx+x, chunky+y) < -.2:
					backgroundTiles.set_cell(chunkx+x, chunky+y, 0)
					backgroundTiles.update_bitmask_area(Vector2(chunkx+x, chunky+y))
		backgroundTiles.z_index = -1
	# -------------------------------------------

	# MINIBIOMES

	for minibiome in planet.miniBiomes:
		yield(get_tree(), "idle_frame")
		if minibiome is Minibiome:
			var generationNoise = minibiome.generationNoise.noise
			if generationNoise.get_noise_2d(chunkx, chunky) > minibiome.rarity:
				continue

			var biomeIndex = planet.miniBiomes.find(minibiome)
			var solids = minibiomeSolids[biomeIndex]
			var miniSolidNoise = minibiome.solidNoise.noise

			for x in planet.chunkSize:
				for y in planet.chunkSize:
					if miniSolidNoise.get_noise_2d(chunkx+x, chunky+y) < minibiome.minNoiseValue\
					and !Vector2(chunkx+x, chunky+y) in minedTiles\
					and tiles.get_cell(chunkx+x, chunky+y) == -1:
						solids.set_cell(chunkx+x, chunky+y, 0)
						shadows.set_cell(chunkx+x, chunky+y, 0)

						solids.update_bitmask_area(Vector2(chunkx+x, chunky+y))
						shadows.update_bitmask_area(Vector2(chunkx+x, chunky+y))


	# --------------------------------------------------------

func remove_chunk(chunkx, chunky):
	for x in 10:
		for y in 10:
			tiles.set_cell(chunkx+x, chunky+y, -1)
			shadows.set_cell(chunkx+x, chunky+y, -1)
			if planet.backgroundTiles:
				backgroundTiles.set_cell(chunkx+x, chunky+y, -1)


# Gets surrounding tiles
func get_neighbors(tilePos : Vector2, tileset : TileMap, getCorners = false) -> Array:
	var xx = -1
	var yy = -1

	var CORNERTILES = [
		Vector2(1, 1),
		Vector2(1, -1),
		Vector2(-1, 1),
		Vector2(-1, -1)
	]

	var neighboringTiles = []

	for tile in range(9):
		if tile == 5:
			continue

		if getCorners:
			neighboringTiles.append(tileset.get_cell(tilePos.x+xx, tilePos.y+yy))
		elif !Vector2(xx, yy) in CORNERTILES:
			neighboringTiles.append(tileset.get_cell(tilePos.x+xx, tilePos.y+yy))

		xx += 1
		xx = wrapi(xx, -1, 2)
		if xx == -1:
			yy += 1
	return neighboringTiles
