extends Resource
class_name WorldGenerator

var worldSize:Vector2 = Vector2(1000, 700)
var hillSize :float = 5
var horizen:int = 500
var roughness:int = 1
var tileSize:int = 8
var heightSmoothing:Curve
var overHangSmoothing:Curve
var caveSize:Curve

var heightNoise
var shiftNoise
var caveNoise

var map := []


func generate_world(
	_heightNoise, _shiftNoise, _caveNoise,
	_heightSmoothing, _overHangSmoothing, _caveSize,
	_hillSize, _horizen, _roughness, _tileSize):

	randomize()
	# Setting noise
	heightNoise = _heightNoise
	shiftNoise = _shiftNoise
	caveNoise = _caveNoise

	# Setting curves
	heightSmoothing = _heightSmoothing
	overHangSmoothing = _overHangSmoothing
	caveSize = _caveSize

	# Setting other properties
	hillSize = _hillSize
	horizen = _horizen
	roughness = _roughness
	tileSize = _tileSize

	heightNoise.seed = randi()
	shiftNoise.seed = randi()
	caveNoise._Seed = randi()

	# Creating the world
	create_world_map()
	add_height()
	for x in map.size():
		for y in map[x].size():
			add_caves(x, y)

	return map;


func create_world_map():
	for x in worldSize.x:
		map.append([])
		for y in worldSize.y:
			map[x].append(-1)


func add_height():
	for x in worldSize.x:
		# Getting the height of the current column.
		var columnHeight = clamp(horizen-round(( (heightNoise.get_noise_1d(x)*tileSize)*hillSize)), 0, worldSize.y)
		columnHeight -= heightSmoothing.interpolate(columnHeight)
		columnHeight -= ceil(rand_range(-roughness, roughness))
		var offset = worldSize.y-columnHeight
		# Creating the column.
		for y in columnHeight:
			map[x][y+offset] = 0


# this function adds caves and overhangs a bit too.
func add_caves(x, y):
	# Getting a threshold value, which decreases the higher up you are.
	var threshold = caveSize.interpolate(y/worldSize.y)
	# Getting a value which needs to pass the threshold to remove a tile.
	caveNoise.thickness = (y/worldSize.y)*threshold
	var caveValue = caveNoise.get_noise_2d(x, y)
	# Removing tiles
	var mapVal = map[x][y]
	if caveValue > threshold and map[x][y] == 0:
		map[x][y] = 1





