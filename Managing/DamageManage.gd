extends Node2D

onready var par:Node = get_parent()

enum {EASY, NORMAL, HARD}

export var maxHealth := 120
export var kbAmount := 32.0
export var upwardsKB := 0.0
export var hurtSFXPath: NodePath
export(int, "Easy", "Normal", "Hard") var difficulty = 1
export(Array, StreamTexture) var corpseSprites: Array
export var useDeathParticles := true
export var isBoss := false
export var freeOnDeath := true
export var steamAchievement := ""
export var spritePath: NodePath
export var bestiaryEntry: Resource

var sprite: Sprite

var hurtSFX:Node2D

var health:int

export var deathParticles = preload("res://Entities/Enemies/Assets/DeathParticles.tscn")
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")
var corpse = preload("res://Entities/Effects/EnemyCorpse.tscn")
var damageBoosters = preload("res://Entities/Enemies/DamageBoostPickup/DamageBoostPickup.tscn")

signal dead
signal damaged

var playerTookDamage := false


func _ready() -> void:
	if spritePath: sprite = get_node(spritePath)
	if hurtSFXPath: hurtSFX = get_node(hurtSFXPath)
	health = maxHealth
	if isBoss:
		var playerData = preload("res://Entities/Player/Player.tres")
		playerData.connect("healthChanged", self, "_on_player_took_damage")


func _on_player_took_damage(_kb: Vector2) -> void:
	if isBoss:
		playerTookDamage = true


func take_damage(amount:float, dir:Vector2) -> void:
	#var dmg := int(amount+rand_range(-2, 1))
	health -= int(amount)
	if par.get("vel"): par.vel = dir*kbAmount-Vector2(0, upwardsKB)

	var newDP = deathParticles.instance()
	newDP.position = global_position
	newDP.rotation = dir.angle()
	newDP.amount = 10
	newDP.process_material = newDP.process_material.duplicate()
	newDP.process_material.emission_sphere_radius = 1
	GameManager.spawnManager.spawn_object(newDP)

	if hurtSFX: hurtSFX.play()

	# Updating the healthbar
	if par.has_method("update_healthbar"):
		par.update_healthbar()

	# Killing thingy
	if health <= 0:
		_die(dir)
	emit_signal("damaged")

	sprite.modulate = Color(100, 100, 100, 1)
	yield(TempTimer.timer(self, .2), "timeout")
	sprite.modulate = Color(1, 1, 1, 1)


func _die(dir: Vector2) -> void:
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

	if corpseSprites.size() > 0:
		for i in corpseSprites:
			var newCorpse = corpse.instance()
			newCorpse.set_sprite(i)
			newCorpse.global_position = global_position
			newCorpse.rotation = rand_range(0, PI * 2)
			newCorpse.apply_central_impulse(dir * rand_range(40, 60))
			newCorpse.apply_torque_impulse(500)
			GameManager.spawnManager.spawn_object(newCorpse)

	var scoreInc: int
	match difficulty:
		EASY:
			scoreInc = Globals.EASY_ENEMY_POINTS
			GameManager.player.playerData.healMaterial += Globals.EASY_MATERIAL_POINTS * (maxHealth / 50.0)
		NORMAL:
			scoreInc = Globals.MEDIUM_ENEMY_POINTS
			GameManager.player.playerData.healMaterial += Globals.MEDIUM_MATERIAL_POINTS * (maxHealth / 60.0)
		HARD:
			scoreInc = Globals.HARD_ENEMY_POINTS
			GameManager.player.playerData.healMaterial += Globals.HARD_MATERIAL_POINTS * (maxHealth / 80.0)
	if isBoss:
		scoreInc += Globals.BOSS_KILL
	else:
		GameManager.emit_signal("screenshake", 1, 2, .025, .1)

		var hurtbox = owner.find_node("Hurtbox")
		yield(TempTimer.idle_frame(self), "timeout")
		if hurtbox.lastHitNode:
			var newDamageBoost = damageBoosters.instance()
			newDamageBoost.global_position = global_position
			GameManager.spawnManager.spawn_object(newDamageBoost)

	GameManager.player.playerData.score += scoreInc
	GameManager.player.playerData.kills += 1

	if steamAchievement != "": Achievement.unlock(steamAchievement)

	if isBoss and !	playerTookDamage:
		Achievement.unlock("NO_HIT")

	if freeOnDeath: par.queue_free()
