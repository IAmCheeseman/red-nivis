extends RigidBody2D

onready var sprite = $Sprite
onready var playerDetection = $PlayerDetection
onready var itemSpawner = $ItemSpawn

onready var itemSpawnerPath = itemSpawner.get_path()

export(Array, Resource) var itemPools

var player


func _ready():
	itemSpawner.itemPool = itemPools


func _process(delta):
	player = playerDetection.get_player()

	if player and Input.is_action_just_pressed("interact") and itemSpawner:
		sprite.play("open")
		GameManager.emit_signal("screenshake", 1, 0, .05, .05, Vector2.ZERO, .95)
		itemSpawner.add_item()
		itemSpawner = null


func _on_animation_finished():
	# Setting the frame to the last frame it was on (loops to first) and stopping it.
	sprite.frame = sprite.frames.get_frame_count(sprite.animation)-1
	sprite.stop()
