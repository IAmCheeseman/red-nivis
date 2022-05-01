extends Node
class_name Achievement

# Achievement.unlock()

static func unlock(ach: String) -> void:
	if Steam.is_init():
		Steam.set_achievement(ach)
	
# Achievement.lock()

static func lock(ach: String) -> void:
	if Steam.is_init():
		Steam.clear_achievement(ach)

# Achievement.is_unlocked()

static func is_unlocked(ach: String) -> bool:
	if Steam.is_init():
		return Steam.get_achievement(ach)
	return false

# Achievement.get_amount()

static func get_amount() -> int:
	if Steam.is_init():
		return Steam.user_stats.get_num_achievements()
	return 0

# Achievement.get_name_by_id()

static func get_name_by_id(idx: int) -> String:
	if Steam.is_init():
		return Steam.user_stats.get_achievement_name(idx)
	return ""
