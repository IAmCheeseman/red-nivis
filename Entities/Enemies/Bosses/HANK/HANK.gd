extends KinematicBody2D

onready var player = GameManager.player

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var walkTimer := $Timers/Walk
onready var attackCooldown := $Timers/AttackCooldown
onready var deathExplodeTimer := $Timers/DeathExplodeTimer

onready var guns = $Sprite/Guns

export var frict := 20
export var attackTimeRange := Vector2(1, 2)
export var speed := 90

var vel := Vector2.ZERO
var target := 0.0
var isDead := false

var drops = [
	preload("res://Items/HeartContiner/HeartContainer.tscn"),
	preload("res://Items/Upgrades/DroppedUpgrade.tscn")
]

var bullets := []

# warning-ignore:unused_signal
signal dead


func _ready() -> void:
	if GameManager.worldData.rooms.size() > 0:
		yield(TempTimer.idle_frame(self), "timeout")
		isDead = GameManager.worldData.get_room_data(self, false)
		if isDead: queue_free()


func _process(delta: float) -> void:
	if !isDead:
		vel.y += Globals.GRAVITY * delta
		var dir = 1 if global_position.x < target else -1
		sprite.scale = sprite.scale.abs().move_toward(Vector2.ONE, 5 * delta)
		
		if abs(global_position.x - target) < 5:
			vel.x = lerp(vel.x, 0, frict * delta)
			anim.play("Idle")
			sprite.scale.x *= 1 if GameManager.player.global_position.x < global_position.x else -1
		else:
			vel.x = dir * speed
			anim.play("Walk")
			sprite.scale.x *= -dir
		
		vel.y = move_and_slide(vel).y


func choose_new_target() -> void:
	target = GameManager.player.global_position.x + rand_range(-128, 128)
	if Utils.coin_flip(): target = global_position.x
	walkTimer.start(rand_range(1, 4))


func _on_animation_changed(_old_name: String, _new_name: String) -> void:
	sprite.scale = Vector2(1.3, .7)


func attack() -> void:
	if isDead: return
	var gunList = guns.get_children()
	for i in gunList.size():
		gunList.shuffle()
		var gun = gunList.pop_front()
		if gun.attack(): break
	attackCooldown.start(rand_range(attackTimeRange.x, attackTimeRange.y))


func _on_dead() -> void:
	GameManager.emit_signal("zoom_in", .75, 2, .2, sprite.global_position)
	GameManager.emit_signal("screenshake", 10, 3, .025, 2)
	var timer = get_tree().create_timer(2.2)
	timer.connect("timeout", self, "add_death_explosion", [64, 3])
	timer.connect("timeout", self, "remove")
	
	isDead = true
	GameManager.worldData.store_room_data(self, true)
	deathExplodeTimer.start()


func remove() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	for i in drops.size():
		var d = drops[i]
		var newDrop:Node2D = d.instance()
		newDrop.position = position-Vector2(0, sprite.texture.get_height()*.25)
		newDrop.position.x += (drops.size()*.5-i)*32
		GameManager.spawnManager.spawn_object(newDrop)
	queue_free()


func add_death_explosion(size:int=8, amt:int=1) -> void:
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
	
	for i in bullets:
		if is_instance_valid(i):
			i.queue_free()
	if amt-1 > 0:
		add_death_explosion(size, amt-1)
