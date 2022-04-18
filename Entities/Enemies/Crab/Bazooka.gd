extends Node2D

onready var sprite = $Sprite
onready var cooldown = $Cooldown

onready var ogPos: float

var player: Node2D

func _ready() -> void:
	ogPos = position.x

func _process(delta: float) -> void:
	if player:
		look_at(player.global_position - Vector2(0, 8))
		sprite.flip_v = player.global_position.x < global_position.x
	position.x = -ogPos if $"..".flip_h else ogPos
	sprite.scale = sprite.scale.move_toward(Vector2.ONE, 3 * delta)


func shoot() -> void:
	cooldown.start(rand_range(2, 3))
	if !player: return
	
	sprite.scale = Vector2(1.6, 0.4)
	
	var dir = Vector2.RIGHT.rotated(rotation)
	
	var newMissile = preload("res://Entities/Enemies/Crab/CrabMissile.tscn").instance()
	newMissile.global_position = global_position + (dir * 16) 
	newMissile.direction = dir
	newMissile.speed = 30
	GameManager.spawnManager.spawn_object(newMissile)
	
	yield(TempTimer.idle_frame(self, 2), "timeout")
	newMissile.set_texture(preload("res://Entities/Enemies/Crab/CrabMissile.png"))
