extends Node2D
class_name EnemySpawner

onready var spawnTimer = Timer.new()

export var spawnInterval:float = 3.0
export var playerPath:NodePath
#export var tilePath:NodePath
export var spawnRange = 16*32
export var stepSize = 16
export(Array, PackedScene) var enemyPool:Array

onready var player:Node2D = get_node(playerPath)
onready var tiles:TileMap

var maxEnemies = 4
var enemyCount = 0

func _ready():
	add_child(spawnTimer)
	spawnTimer.connect("timeout", self, "spawn_enemy")
	spawnTimer.wait_time = spawnInterval
	spawnTimer.start()


func spawn_enemy(enemy=null) -> void:
	if enemyCount >= maxEnemies:
		return
	enemyPool.shuffle()
	var newEnemy = enemyPool.front().instance()
	var _position = Vector2(-1, -1)
	while _position == Vector2(-1, -1)\
	or tiles.get_cellv(tiles.world_to_map(_position)) != -1\
	or tiles.get_cellv(tiles.world_to_map(_position+Vector2(0, 16))) == -1:
		var relativePos = Vector2.RIGHT.rotated(deg2rad(rand_range(0, 360)))
		relativePos *= stepify(rand_range(get_viewport_rect().end.x, spawnRange), tiles.cell_size.x)
		_position = player.position+relativePos
	newEnemy.position = _position
	newEnemy.connect("dead", self, "_on_enemy_dead")
	GameManager.spawnManager.spawn_object(newEnemy)
	enemyCount += 1


func _on_enemy_dead():
	enemyCount -= 1



