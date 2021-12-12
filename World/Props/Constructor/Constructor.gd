extends Node2D

onready var sparkSpawnPos = $SparkSpawnPos
onready var anim = $AnimationPlayer
onready var dingSFX = $DingSFX
onready var bzztSFX = $BzztSFX
onready var timer = $SpawnTimer

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
		bzztSFX.play()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		open_door()


func open_door() -> void:
	if !player.playerObject.lockMovement:
		return
	timer.stop()
	anim.play("Open")
	dingSFX.play()
