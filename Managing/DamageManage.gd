extends Node2D

onready var par:Node = get_parent()


export var maxHealth := 120
export var kbAmount := 32.0
export var hurtSFXPath: NodePath

onready var hurtSFX = get_node(hurtSFXPath)

var health:int

var deathParticles = preload("res://Entities/Enemies/Assets/DeathParticles.tscn")
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")
var damageLabel = preload("res://Entities/Effects/DmgLabel.tscn")


func _ready() -> void:
	health = maxHealth


func take_damage(amount:float, dir:Vector2) -> void:
	var dmg = amount + rand_range(-2, 2)
	health -= int(dmg)
	par.vel = dir*kbAmount
	
	# Instancing label for damage
	var newDL = damageLabel.instance()
	newDL.rect_position = global_position
	newDL.text = str(int(dmg))
	
	# Adding damage label
	var nn = Node2D.new()
	nn.z_index = 100
	GameManager.spawnManager.spawn_object(nn)
	nn.add_child(newDL)
	
	if hurtSFX: hurtSFX.play()
	
	# Updating the healthbar
	if par.has_method("update_healthbar"):
		par.update_healthbar()
	
	# Killing thingy
	if health <= 0:
		_die(dir)


func _die(dir) -> void:
	# Instancing death particles
	var newDP = deathParticles.instance()
	newDP.position = global_position
	newDP.rotation = dir.angle()
	GameManager.spawnManager.spawn_object(newDP)
	
	# Freezing game
	GameManager.frameFreezer.freeze_frames(.07)
	
	# Adding health pickup
	if rand_range(0, 1) < Globals.HEART_CHANCE:
		var newHealth = healthPickup.instance()
		newHealth.position = global_position
		GameManager.spawnManager.spawn_object(newHealth)
	
	if par.has_signal("death"):
		par.emit_signal("death")
	
	par.queue_free()
