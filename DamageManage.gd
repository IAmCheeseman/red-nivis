extends Node2D

onready var par:Node = get_parent()


export var maxHealth := 120
export var kbAmount := 32.0

var health:int

var deathParticles = preload("res://Entities/Enemies/Assets/DeathParticles.tscn")
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")


func _ready() -> void:
	health = maxHealth


func take_damage(amount:float, dir:Vector2) -> void:
# warning-ignore:narrowing_conversion
	health -= amount
	par.vel = dir*kbAmount
	if health <= 0:
		var newDP = deathParticles.instance()
		newDP.position = global_position
		newDP.rotation = dir.angle()
		GameManager.spawnManager.spawn_object(newDP)
		GameManager.frameFreezer.freeze_frames(.07)
		
		if rand_range(0, 1) < Globals.HEART_CHANCE:
			var newHealth = healthPickup.instance()
			newHealth.position = global_position
			GameManager.spawnManager.spawn_object(newHealth)
		if par.has_signal("death"):
			par.emit_signal("death")
		
		par.queue_free()
	
	if par.has_method("update_healthbar"):
		par.update_healthbar()
