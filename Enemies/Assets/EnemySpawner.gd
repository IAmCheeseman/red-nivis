extends Position2D

export var enemyTable:Resource = preload("res://Enemies/Assets/BasicEnemies.tres")

func spawn_enemy(amount:int):
	if enemyTable is EnemyTable:
		for _i in amount:
			var index = round(rand_range(0, enemyTable.enemies.size()-1))
			while rand_range(0, 1) > enemyTable.chances[index]:
				index = round(rand_range(0, enemyTable.enemies.size()-1))
			var enemy = enemyTable.enemies[index].instance()
			enemy.position = position+Vector2(rand_range(-24, 24), rand_range(-24, 24))
			GameManager.spawnManager.spawn_object(enemy)
			
