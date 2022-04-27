extends Node2D

onready var parent = $"../../"

var percentage := 0.0
var startPos: Vector2
var endPos: Vector2


func test() -> bool:
	if parent.headless:
		startPos = parent.global_position
		percentage = 0
		return true
	return false


func attack(delta: float) -> void:
	if parent.state == parent.ATTACK:
		var moveVec = startPos.direction_to(endPos) * startPos.distance_to(endPos)
		parent.global_position = startPos + (moveVec * percentage)
		
		percentage += delta * 4
		
		if percentage >= 1:
			parent.state = parent.WALK
			parent.vel = moveVec.normalized() * parent.uppercutForce
