extends Position2D

export var enemyTable:Resource = preload("res://Entities/Enemies/Assets/BasicEnemies.tres")
export var spawnRange = 24

func spawn_enemy(amount:int):
	if enemyTable is EnemyTable:
		for _i in amount:
			var index = round(rand_range(0, enemyTable.enemies.size()-1))
			while rand_range(0, 1) > enemyTable.chances[index]:
				index = round(rand_range(0, enemyTable.enemies.size()-1))
			var enemy = enemyTable.enemies[index].instance()
			enemy.global_position = global_position+Vector2(rand_range(-spawnRange, spawnRange), rand_range(-spawnRange, spawnRange))
			GameManager.spawnManager.spawn_object(enemy)
			
