extends Resource
class_name Walker

enum {UP, DOWN, LEFT, RIGHT}


var directions:PoolVector2Array = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]


export var maxSteps:int = 12
export var stepJump:int = 5
export(Array, int, "up", "down", "left", "right") var blacklistedTurns:Array
export var turnChance:float = .25


var position:Vector2
var direction:Vector2
var startingPosition:Vector2
var area:Rect2

var endWalk:bool = false


func _init(_startPos:Vector2, _area:Rect2, newTurnBlacklist:Array=[]) -> void:
	startingPosition = _startPos
	area = _area
	blacklistedTurns = newTurnBlacklist if newTurnBlacklist != [] else blacklistedTurns


func walk() -> PoolVector2Array:
	# Removing blacklisted turns
	for direction in blacklistedTurns:
		directions.remove(direction)
	
	var steps:PoolVector2Array = []
	
	for s in maxSteps:
		position = step(position, direction, area)
		steps.append(position)
	
	return steps


func step(position:Vector2, direction:Vector2, area:Rect2) -> Vector2:
	var newPosition = position+direction*stepJump
	if !area.has_point(newPosition) or rand_range(0, 1) < turnChance:
		change_direction()
	return newPosition


func change_direction() -> void:
	var dirDupe:Array = dupe_arr(directions)
	dirDupe.shuffle()
	for dir in dirDupe:
		if area.has_point(position+dir*stepJump):
			direction = dir
			return
		dirDupe.pop_front()
	endWalk = true


func back(array):
	return array[array.size()]


func dupe_arr(array) -> Array:
	var newArr:Array
	for i in array: newArr.append(i)
	return newArr
