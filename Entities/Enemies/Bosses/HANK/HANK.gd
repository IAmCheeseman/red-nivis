extends KinematicBody2D

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var bossBar = $CanvasLayer/Bossbar

onready var walkTimer := $Timers/Walk
onready var attackCooldown := $Timers/AttackCooldown
onready var deathExplodeTimer := $Timers/DeathExplodeTimer

onready var playerDetection := $Collisions/PlayerDetection

onready var guns = $Sprite/Guns

onready var dropper = $BossDropper

onready var landParticles1 = $Sprite/LandParticles1
onready var landParticles2 = $Sprite/LandParticles2

onready var explosionSFX = $ExplosionSFX

export var frict := 20
export var attackTimeRange := Vector2(1, 2)
export var speed := 90

var player: Node2D

var vel := Vector2.ZERO
var target := 0.0
var isDead := false

var bullets := []

# warning-ignore:unused_signal
signal dead


func _ready() -> void:
	#MusicManager.set_music(preload("res://Entities/Enemies/Bosses/FunkyAcid.mp3"), 25)
	if GameManager.worldData.rooms.size() > 0:
		yield(TempTimer.idle_frame(self), "timeout")
		isDead = GameManager.worldData.get_room_data(self, false)
		if isDead: queue_free()


func _process(delta: float) -> void:
	if !player:
		player = playerDetection.get_player()
		bossBar.hide()
		return
	bossBar.show()
	if !isDead:
		vel.y += Globals.GRAVITY * delta
		var dir = 1 if global_position.x < target else -1
		sprite.scale = sprite.scale.abs().move_toward(Vector2.ONE, 5 * delta)

		if abs(global_position.x - target) < 5:
			vel.x = lerp(vel.x, 0, frict * delta)
			anim.play("Idle")
			sprite.scale.x *= 1 if player.global_position.x < global_position.x else -1
		else:
			vel.x = dir * speed
			anim.play("Walk")
			sprite.scale.x *= -dir

		vel.y = move_and_slide(vel).y


func choose_new_target() -> void:
	walkTimer.start(rand_range(1, 4))
	if !player: return
	target = player.global_position.x + rand_range(-128, 128)
	if Utils.coin_flip(): target = global_position.x


func _on_animation_changed(_old_name: String, _new_name: String) -> void:
	sprite.scale = Vector2(1.3, .7)


func attack() -> void:
	attackCooldown.start(rand_range(attackTimeRange.x, attackTimeRange.y))
	if isDead: return
	if !player: return
	var gunList = guns.get_children()
	for i in gunList.size():
		gunList.shuffle()
		var gun = gunList.pop_front()
		if gun.attack(): break


func _on_dead() -> void:
	GameManager.emit_signal("zoom_in", .75, 2, .2, sprite.global_position)
	GameManager.emit_signal("screenshake", 10, 3, .025, 2)
	var timer = get_tree().create_timer(2.2)
	timer.connect("timeout", self, "add_death_explosion", [64, 3])
	timer.connect("timeout", self, "emit_signal", ["dead"])
	timer.connect("timeout", self, "queue_free")
	
	remove_child(explosionSFX)
	GameManager.spawnManager.spawn_object(explosionSFX)
	
	isDead = true
	GameManager.worldData.store_room_data(self, true)
	deathExplodeTimer.start()


func add_death_explosion(size:int=32, amt:int=1) -> void:
	var newExplosion = preload("res://Entities/Enemies/Explosion/ExplosionParticles.tscn").instance()
	var pos = sprite.global_position
	var spawnRange = sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)
	pos += Vector2(rand_range(0, spawnRange.x), rand_range(0, spawnRange.y))
	pos -= spawnRange / 2
	newExplosion.global_position = pos

	newExplosion.emitting = true
	newExplosion.process_material = newExplosion.process_material.duplicate()
	newExplosion.process_material.emission_sphere_radius = size
	newExplosion.z_index = 2
	GameManager.spawnManager.add_child(newExplosion)

	var timer = get_tree().create_timer(.5)
	timer.connect("timeout", newExplosion, "queue_free")

	explosionSFX.play()

	for i in bullets:
		if is_instance_valid(i):
			i.queue_free()
	if amt - 1 > 0:
		add_death_explosion(size, amt-1)


func dash() -> void:
	var dir = -1 if Utils.coin_flip() else 1
	vel.x = dir * 1000
