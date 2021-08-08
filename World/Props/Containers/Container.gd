extends KinematicBody2D

onready var sprite = $Sprite
onready var playerDetection = $PlayerDetection
onready var itemSpawner = $ItemSpawn
onready var animationPlayer = $AnimationPlayer

onready var itemSpawnerPath = itemSpawner.get_path()

export(Array, Resource) var itemPools
export var itemCountRange:Vector2 = Vector2(1, 2)

var player

signal containerOpened


func _ready():
	itemSpawner.itemPool = itemPools
	if test_move(transform, Vector2.ZERO): queue_free()


func _process(delta):
	player = playerDetection.get_player()
	if player and Input.is_action_just_pressed("interact") and itemSpawner:
		for i in round(rand_range(itemCountRange.x, itemCountRange.y)):
			itemSpawner.add_item()
		itemSpawner.queue_free()
		itemSpawner = null
		emit_signal("containerOpened")

		# Visual
		animationPlayer.stop()
		sprite.play("open")
		sprite.scale = Vector2.ONE
		GameManager.emit_signal("screenshake", 1, 5, .05, .05)

# warning-ignore:return_value_discarded
	move_and_collide(Vector2.DOWN*(GameManager.gravity*delta))
	position = position.round()


func _on_animation_finished():
	# Setting the frame to the last frame it was on (loops to first) and stopping it.
	sprite.frame = sprite.frames.get_frame_count(sprite.animation)-1
	sprite.stop()
