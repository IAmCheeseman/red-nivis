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


func _process(_delta):
	update_queued_chunks()
	update_chunks()
	clean_chunks()
	ruin_chunks()
	add_props()
	add_enemy()


func update_queued_chunks():
	var chunkSize = worldGenerater.planet.chunkSize
	var currentChunk = ((player.position/chunkSize)/16).round()

	if !currentChunk.is_equal_approx(lastChunk) or firstTime:
		firstTime = false
		queuedChunks = get_neighbors(currentChunk, chunkAmount)
		for chunk in generatedChunks:
			if !chunk in queuedChunks:
				queueFreeChunks.append(chunk)
				generatedChunks.erase(chunk)

		for chunk in queuedChunks:
			if chunk in generatedChunks:
				queuedChunks.erase(chunk)
	lastChunk = currentChunk


func update_chunks():
	var chunkSize = worldGenerater.planet.chunkSize
	var chunk = queuedChunks.pop_front()
	if chunk or chunk == Vector2.ZERO:
		worldGenerater.generate_chunk(chunk.x*chunkSize, chunk.y*chunkSize)
		generatedChunks.append(chunk)


func add_props():
	for chunk in generatedChunks:
		if chunk in propedChunks or worldGenerater.planet.props.size() == 0:
			continue


		yield(get_tree(), "idle_frame")
		propedChunks.append(chunk)
		seed(chunk.y+chunk.x+worldGenerater.worldSeed)


# warning-ignore:shadowed_variable
		var tiles = worldGenerater.tiles
		var chunkx = (chunk.x*10)*16
		var chunky = (chunk.y*10)*16
		var spawnRange = worldGenerater.planet.chunkSize*tiles.cell_size.x

		var propPosition = Vector2(rand_range(chunkx, chunkx+spawnRange),\
		rand_range(chunky, chunky+spawnRange)).round()
		seed(chunk.y+chunk.x+worldGenerater.worldSeed)
		if tiles.get_cellv(tiles.world_to_map(propPosition)) != -1\
		or rand_range(0, 9) > 1:
			continue
		var propList = worldGenerater.planet.props
		propList.shuffle()
		var prop = propList[0].instance()
		prop.position = propPosition
		props.add_child(prop)


func ruin_chunks():
	for chunk in generatedChunks:
		if chunk in ruinedChunks or !is_inside_tree():
			continue

		yield(get_tree(), "idle_frame")
		ruinedChunks.append(chunk)
		seed(chunk.y+chunk.x+worldGenerater.worldSeed)


# warning-ignore:shadowed_variable
		var tiles = worldGenerater.tiles
		var chunkx = (chunk.x*10)*16
		var chunky = (chunk.y*10)*16
		var spawnRange = worldGenerater.planet.chunkSize*tiles.cell_size.x

		var ruinPosition = Vector2(rand_range(chunkx, chunkx+spawnRange),\
		rand_range(chunky, chunky+spawnRange)).round()

		if rand_range(0, worldGenerater.planet.ruinChance) > 1\
		or tiles.get_cellv(tiles.world_to_map(ruinPosition)) != -1:
			continue
		var ruinHandler = RuinHandler.new()
		var ruins = ruinHandler.get_ruins(true)
		ruins.shuffle()

		var ruin = ruins[0].scene.instance()

		if ruins[0].customPosition != Vector2.LEFT: ruin.position = ruins[0].customPosition.round()
		else: ruin.position = ruinPosition.round()
		ruin.worldGenerator = worldGenerater

		props.add_child(ruin)

		ruin.chunk = chunk
		ruin.set_color(worldGenerater.planet.ruinColor)


func clean_chunks():
	var chunkSize = worldGenerater.planet.chunkSize
	var chunk = queueFreeChunks.pop_front()
	if chunk:
		worldGenerater.remove_chunk(chunk.x*chunkSize, chunk.y*chunkSize)


func add_enemy():
	if enemyCount <= maxEnemies and worldGenerater.planet.enemies.size() > 0:
		var planet = worldGenerater.planet
		var enemies = planet.enemies
		var enemyChances = planet.enemyChances
# warning-ignore:shadowed_variable
		var tiles = worldGenerater.tiles
		var maxEnemySpawnDist = 16*25
		var minEnemySpawnDist = 16*15

		var angle = Vector2.RIGHT.rotated(rand_range(0, 360))
		var distance = rand_range(minEnemySpawnDist, maxEnemySpawnDist)

		var spawnPosition = player.position+(angle*distance)
		var enemyIndex = rand_range(0, enemies.size())

		var localPos = tiles.to_local(spawnPosition)
		if tiles.get_cellv(tiles.world_to_map(localPos)) != -1\
		or rand_range(0, 100) > enemyChances[enemyIndex]:
			return

		var enemy = enemies[enemyIndex].instance()
		enemy.position = spawnPosition
		enemy.tiles = worldGenerater.tiles
		enemy.set_player(worldGenerater.player)
		enemy.set_world(self)
		props.add_child(enemy)
		enemyCount += 1


func get_neighbors(pos : Vector2, size : int) -> Array:
	var xx = -size
	var yy = -size

	var neighboringPos = []

	for tile in (size*2)*(size*2):
		neighboringPos.append(Vector2(pos.x+xx, pos.y+yy))

		xx += 1
		xx = wrapi(xx, -size, size+1)
		if xx == -size:
			neighboringPos.append(Vector2(pos.x, pos.y+yy))
			yy += 1
	return neighboringPos


func _on_World_tree_entered():
	get_tree().current_scene = self
	name = "World"
	yield(get_tree(), "idle_frame")
	atmosphere.color = GameManager.planet.atmosphereColor
