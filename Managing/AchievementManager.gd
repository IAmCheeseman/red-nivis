extends Node
class_name Achievement

# Achievement.unlock()

static func unlock(ach: String) -> void:
	if Steam.is_init():
		Steam.set_achievement(ach)
	
	# Saving the achievement so if the player didn't get it this time, they
	# will next time they boot.
	var playerData = preload("res://Entities/Player/Player.tres")
	playerData.unlockedAchievements.append(ach)

# Achievement.lock()

static func lock(ach: String) -> void:
	if Steam.is_init():
		Steam.clear_achievement(ach)
	
	# Clearing save.
	var playerData = preload("res://Entities/Player/Player.tres")
	playerData.unlockedAchievements.erase(ach)
