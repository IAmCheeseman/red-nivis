extends Position2D

export var enemyTable:Resource = preload("res://World/EnemyPools/BasicEnemies.tres")
export var spawnRange = 24

signal enemy_added(enemy)

func spawn_enemy(amount:int):
	if enemyTable is EnemyTable:
		for _i in amount:
			var enemy = enemyTable.get_random_enemy().instance()
			enemy.global_position = global_position+Vector2(rand_range(-spawnRange, spawnRange), rand_range(-spawnRange, spawnRange))
			GameManager.spawnManager.spawn_object(enemy)
			emit_signal("enemy_added", enemy)
