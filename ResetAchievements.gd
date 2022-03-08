extends Node

export(int, "Add", "Remove") var mode := 0
export var ach := "PARTICIPATE"

func _ready() -> void:
	print("Is Steam working? %s." % Steam.is_init())
	if mode == 0:
		if ach == "ALL":
			for i in Steam.user_stats.get_num_achievements():
				Steam.set_achievement(Steam.user_stats.get_achievement_name(i))
		else:
			Steam.set_achievement(ach)
	elif mode == 1:
		if ach == "ALL":
			for i in Steam.user_stats.get_num_achievements():
				Steam.clear_achievement(Steam.user_stats.get_achievement_name(i))
		else:
			Steam.clear_achievement(ach)
