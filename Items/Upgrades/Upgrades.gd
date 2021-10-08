extends Reference

const TELEPORT = preload("res://Items/Upgrades/Teleport/Teleport.tres")
const DOUBLE_JUMP = preload("res://Items/Upgrades/DoubleJump/DoubleJump.tres")
const WALL_JUMP = preload("res://Items/Upgrades/StickyGlove/WallJump.tres")

static func get_upgrade_array() -> Array:
	return [
		TELEPORT,
		DOUBLE_JUMP,
		WALL_JUMP
	]
