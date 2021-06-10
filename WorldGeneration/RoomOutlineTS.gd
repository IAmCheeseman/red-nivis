extends TileMap
tool

export var allowGeneration = false setget setAllowGen
export var minDepth = .5 setget setMinDepth
export var size = Vector2(10, 10) setget setSize


func clear_tiles():
	var usedTiles = get_used_cells()
	for tile in usedTiles:
		set_cellv(tile, -1)


func generateRoom():
	clear_tiles()

	var noise = OpenSimplexNoise.new()
	noise.seed = randi()

	var noiseImage = noise.get_image(400, 400)
	noiseImage.shrink_x2()
	noiseImage.lock()

	for x in size.x:
		for y in size.y:
			if noiseImage.get_pixel(x, y).r < minDepth\
			or x == 0 or x == size.x-1\
			or y == 0 or y == size.y-1:
				set_cell(x, y, 0)


func setAllowGen(value):
	allowGeneration = value
	if value:
		generateRoom()


func setMinDepth(value):
	if !allowGeneration:
		return
	minDepth = value

	generateRoom()


func setSize(value):
	if !allowGeneration:
		return
	size = value

	generateRoom()

