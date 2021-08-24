extends KinematicBody2D

onready var sprite = $Sprite
onready var playerDetection = $PlayerDetection
onready var itemSpawner = $ItemSpawn
onready var animationPlayer = $AnimationPlayer
onready var queueCollision = $QueueCollision
onready var openSFX = $OpenSound

onready var itemSpawnerPath = itemSpawner.get_path()

export(Array, Resource) var itemPools
export var itemCountRange:Vector2 = Vector2(1, 2)
export(float, 0, 1) var deathChance = .5

var player
var vel = Vector2.ZERO

signal containerOpened


func _ready():
	itemSpawner.itemPool = itemPools
	if queueCollision.get_overlapping_bodies().size() > 0:
		queue_free()
	if rand_range(0, 1) < deathChance:
		queue_free()
	queueCollision.queue_free()
	sprite.material = sprite.material.duplicate()



func _process(delta):
	player = playerDetection.get_player()
	
	# Outlining it if you're close enough
	if player and itemSpawner:
		sprite.material.set_shader_param("line_thickness", 1)
	else:
		sprite.material.set_shader_param("line_thickness", 0)
	
	if player and Input.is_action_just_pressed("interact") and itemSpawner:
		openSFX.play()
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
	vel.y += (Vector2.DOWN*(GameManager.gravity*delta)).y
	vel.y = move_and_slide(vel).y
	position = position.round()


func _on_animation_finished():
	# Setting the frame to the last frame it was on (loops to first) and stopping it.
	sprite.frame = sprite.frames.get_frame_count(sprite.animation)-1
	sprite.stop()
