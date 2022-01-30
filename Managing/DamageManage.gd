extends Node2D

onready var par:Node = get_parent()

enum {EASY, NORMAL, HARD}

export var maxHealth := 120
export var kbAmount := 32.0
export var upwardsKB := 0.0
export var hurtSFXPath: NodePath
export(int, "Easy", "Normal", "Hard") var difficulty = 1
export var useDeathParticles := true
export var isBoss := false
export var freeOnDeath := true

var hurtSFX:Node2D

var health:int

var deathParticles = preload("res://Entities/Enemies/Assets/DeathParticles.tscn")
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")
var damageLabel = preload("res://Entities/Effects/DmgLabel.tscn")

signal dead
signal damaged


func _ready() -> void:
	if hurtSFXPath: hurtSFX = get_node(hurtSFXPath)
	health = maxHealth


func take_damage(amount:float, dir:Vector2) -> void:
	var dmg := int(amount+rand_range(-2, 1))
	health -= dmg
	if par.get("vel"): par.vel = dir*kbAmount-Vector2(0, upwardsKB)
	
	# Instancing label for damage
	var newDL = damageLabel.instance()
	newDL.rect_position = global_position
	newDL.text = str(dmg)
	
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
	emit_signal("damaged")


func _die(dir) -> void:
	emit_signal("dead")
	# Instancing death particles
	if useDeathParticles:
		var newDP = deathParticles.instance()
		newDP.position = global_position
		newDP.rotation = dir.angle()
		GameManager.spawnManager.spawn_object(newDP)
	
	# Adding health pickup
	if rand_range(0, 1) < Globals.HEART_CHANCE:
		var newHealth = healthPickup.instance()
		newHealth.position = global_position
		GameManager.spawnManager.spawn_object(newHealth)
	
	if par.has_signal("death"):
		par.emit_signal("death")
	
	var scoreInc: int
	match difficulty:
		EASY: scoreInc = Globals.EASY_ENEMY_POINTS
		NORMAL: scoreInc = Globals.MEDIUM_ENEMY_POINTS
		HARD: scoreInc = Globals.HARD_ENEMY_POINTS
	if isBoss: scoreInc += Globals.BOSS_KILL
	
	GameManager.player.playerData.score += scoreInc
	GameManager.player.playerData.kills += 1
	
	if freeOnDeath: par.queue_free()
