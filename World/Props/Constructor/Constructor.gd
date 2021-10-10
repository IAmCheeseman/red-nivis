extends Node2D

onready var sparkSpawnPos = $SparkSpawnPos
onready var anim = $AnimationPlayer

var player = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	player.playerObject.lockMovement = true
	player.playerObject.hide()


func display_player() -> void:
	player.playerObject.lockMovement = false
	player.playerObject.show()
	player.playerObject.jump()


func add_sparks():
	var spark = preload("res://Entities/Effects/Spark.tscn")
	for i in rand_range(2, 4):
		var newSpark = spark.instance()
		newSpark.position = Vector2.RIGHT.rotated(rand_range(0, 2*PI))*rand_range(4, 24)
		newSpark.position += sparkSpawnPos.position
		add_child(newSpark)


func open_door() -> void:
	anim.play("Open")
