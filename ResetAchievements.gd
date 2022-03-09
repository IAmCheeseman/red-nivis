extends Node

export(int, "Unlock", "Lock") var mode := 0
export var ach := "PARTICIPATE"

func _ready() -> void:
	print("Is Steam working? %s." % Steam.is_init())
	if mode == 0:
		if ach == "ALL":
			for i in Steam.user_stats.get_num_achievements():
				Achievement.unlock(Steam.user_stats.get_achievement_name(i))
		else:
			Achievement.unlock(ach)
	elif mode == 1:
		if ach == "ALL":
			for i in Steam.user_stats.get_num_achievements():
				Achievement.lock(Steam.user_stats.get_achievement_name(i))
		else:
			Achievement.lock(ach)
