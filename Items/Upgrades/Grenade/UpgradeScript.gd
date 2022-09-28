extends Node


const BOMBS = [
	{
		"texture" : preload("res://Items/Upgrades/Grenade/Grenade.tscn"),
		"explosion" : preload("res://Items/Upgrades/Grenade/Grenade.tscn")
	},
]

var bomb = preload("res://Items/Upgrades/Grenade/Grenade.tscn")

var baseThrowStrength := 1

var cooldown: Timer
var player: Node2D


func _ready() -> void:
	cooldown = Timer.new()
	cooldown.one_shot = true
	cooldown.wait_time = 10
	add_child(cooldown)


func _process(_delta: float) -> void:
	player.playerData.emit_signal("updateGrenade", cooldown.time_left, true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grenade") and cooldown.is_stopped():
		var newBomb = bomb.instance()
		newBomb.explosion = BOMBS[player.playerData.bombType].explosion
		newBomb.global_position = player.global_position - Vector2(0, 8)
		var mousePos = player.get_local_mouse_position()
		var throwStrength:float = clamp(mousePos.length() * 3, 0, 128 * 3)
		newBomb.apply_central_impulse(
			mousePos.normalized() * throwStrength # `mousePos` acts as a direction, since it's local
		)
		GameManager.spawnManager.spawn_object(newBomb)
		cooldown.start()
