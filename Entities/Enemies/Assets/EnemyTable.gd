extends Resource
class_name EnemyTable

export(Array, PackedScene) var enemies:Array
export(Array, float, 0, 1) var chances:Array


func get_random_enemy() -> PackedScene:
	while true:
		var index = floor(rand_range(0, enemies.size()))
		if rand_range(0, 1) < chances[index]:
			return enemies[index]
	return enemies[0]
