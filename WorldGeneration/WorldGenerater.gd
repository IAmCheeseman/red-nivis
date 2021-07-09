extends Resource
class_name WorldGenerator

export var worldSize:Vector2 = Vector2(1000, 700)
export var strength:float = 5
export var horizen:int = 500
export var roughness:int = 1
export var tileSize:int = 8
export var shiftDirection:Vector2 = Vector2.LEFT
export var shiftStrength:int = 5
var heightSmoothing:Curve
var overHangSmoothing:Curve
var caveSize:Curve

var heightNoise
var shiftNoise
var caveNoise

var map := []


func generate_world(
	_heightNoise, _shiftNoise, _caveNoise,
	_heightSmoothing, _overHangSmoothing, _caveSize):
	randomize()
	heightNoise = _heightNoise.noise
	shiftNoise = _shiftNoise.noise
	caveNoise = _caveNoise.noise

	heightSmoothing = _heightSmoothing
	overHangSmoothing = _overHangSmoothing
	caveSize = _caveSize

	heightNoise.seed = randi()
	shiftNoise.seed = randi()
	caveNoise.seed = randi()

	# Creating the world
	create_world_map()
	add_height()
	for x in map.size():
		for y in map[x].size():
			shift_tiles(x, y)
			add_caves(x, y)
	clean_up()

	return map;


func create_world_map():
	for x in worldSize.x:
		map.append([])
		for y in worldSize.y:
			map[x].append(-1)


func add_height():
	for x in worldSize.x:
		# Getting the height of the current column.
		var columnHeight = clamp(horizen-round(( (heightNoise.get_noise_1d(x)*tileSize)*strength)), 0, worldSize.y)
		columnHeight -= heightSmoothing.interpolate(columnHeight)
		columnHeight -= ceil(rand_range(0, roughness))
		var offset = worldSize.y-columnHeight
		# Creating the column.
		for y in columnHeight:
			map[x][y+offset] = 0


func shift_tiles(x, y):
	pass


func add_caves(x, y):
	var threshold = caveSize.interpolate(y/worldSize.y)
	var caveValue = caveNoise.get_noise_2d(x, y)
	if caveValue > threshold:
		map[x][y] = -1


func clean_up():
	var kill = 3
	var iterations = 2

	for i in iterations:
		var changes = []
		for x in worldSize.x:
			for y in worldSize.y:
				var neighbors = get_neighbors(Vector2(x, y))
				var aliveCells = 0
				for cell in neighbors:
					if map[cell.x-1][cell.y-1] == -1:
						aliveCells += 1
				if aliveCells >= kill:
					changes.append({
						"x" : x,
						"y" : y,
						"val" : -1
					})
		for change in changes:
			map[change.x][change.y] = change.val


func get_neighbors(pos:Vector2):
	return [
		pos+Vector2.LEFT,
		pos+Vector2.RIGHT,
		pos+Vector2.UP,
		pos+Vector2.DOWN,
		pos+(Vector2.LEFT+Vector2.UP),
		pos+(Vector2.RIGHT+Vector2.UP),
		pos+(Vector2.LEFT+Vector2.DOWN),
		pos+(Vector2.RIGHT+Vector2.DOWN)
	]




