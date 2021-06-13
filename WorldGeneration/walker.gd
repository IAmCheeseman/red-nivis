extends Node
class_name DrunkWalker

const DIRECTIONS = [
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.DOWN,
	Vector2.UP
]


var maxSteps : int
var maxStepsDir : int
var viableArea : Rect2
var amountOfWalkers : int
var directionChance : float

var stop = false


func _init(_maxSteps, _viableArea, _amountOfWalkers, _directionChance, _maxStepsDir):
	maxSteps = _maxSteps
	viableArea = _viableArea
	amountOfWalkers = _amountOfWalkers
	directionChance = _directionChance
	maxStepsDir = _maxStepsDir



func walk() -> Array:
	var positions = []

	for walker in amountOfWalkers:
		var stepPosition = Vector2(Vector2.ONE).round()

		var stepsInDir = 0

		var directions = DIRECTIONS.duplicate()
		directions.shuffle()
		var currentDirection = directions[0]

		for step in maxSteps:
			stepsInDir += 1

			if stepsInDir == maxStepsDir:
				stepsInDir = 0
				currentDirection = change_direction(stepPosition, currentDirection)

			positions.append(stepPosition)
			var posDir = step(stepPosition, currentDirection)
			stepPosition = posDir[0]
			currentDirection = posDir[1]

			if rand_range(0, 100) < directionChance:
				currentDirection = change_direction(stepPosition, currentDirection)

			if stop or !viableArea.has_point(stepPosition):
				break

		stop = false

	return positions



func step(stepPosition, direction) -> Array:
	var newPosition = stepPosition+direction
	var newDirection = direction

	if !viableArea.has_point(newPosition):
		newDirection = change_direction(stepPosition, direction)
		newPosition = stepPosition+newDirection
	return [newPosition, newDirection]



func change_direction(stepPosition, currentDirection) -> Vector2:
	var directions = DIRECTIONS.duplicate()

	directions.erase(-currentDirection)
	directions.shuffle()
	var direction = directions.pop_front()

	var loops = 0
	while !viableArea.has_point(stepPosition+direction) and loops != 4:
		if directions.empty():
			stop = true
			break
		direction = directions.pop_front()
	if loops == 4:
		stop = true

	return direction
