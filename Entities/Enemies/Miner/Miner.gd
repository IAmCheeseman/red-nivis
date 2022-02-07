extends KinematicBody2D

const SPIDER = preload("res://Entities/Enemies/TinySpider/TinySpider.tscn")
const MAX_SPIDERS = 4

enum { WANDER, ATTACK }

onready var sprite := $Sprite
onready var anim := $AnimationPlayer

onready var spiderSpawn := $Sprite/SpiderSpawn

onready var walkTimer := $Timers/Walk
onready var attackCooldown := $Timers/Attack

onready var healthManager = $DamageManager
onready var hpBar = $Healthbar

export var frict := 20
export var speed := 90
export var attackTimeRange := Vector2(1, 2)

var state := WANDER

var vel := Vector2.ZERO
var target := 0

var spiders := []


func _ready() -> void:
	update_healthbar()


func _process(delta: float) -> void:
	match state:
		WANDER:
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
		ATTACK:
			vel.x = lerp(vel.x, 0, frict * delta)


func choose_new_target() -> void:
	target = int(GameManager.player.global_position.x + rand_range(-128, 128))
	if Utils.coin_flip(): target = int(global_position.x)
	walkTimer.start(rand_range(1, 4))


func spawn_spiders() -> void:
	for i in 2:
		var newSpider = SPIDER.instance()
		newSpider.global_position = spiderSpawn.global_position
		newSpider.vel = Vector2.RIGHT.rotated(rand_range(0, PI * 2)) * rand_range(0, 200)
		GameManager.spawnManager.spawn_object(newSpider)
		newSpider.connect("dead", self, "remove_spider", [newSpider])
		spiders.append(newSpider)


func remove_spider(spider: Node2D) -> void:
	spiders.erase(spider)


func wander() -> void:
	state = WANDER
	attackCooldown.start(rand_range(attackTimeRange.x, attackTimeRange.y))


func attack() -> void:
	anim.play("Attack")
	state = ATTACK


func throw_head() -> void:
	var newHead = preload("res://Entities/Enemies/Miner/EnemyBoomerang.tscn").instance()
	newHead.direction = (global_position - Vector2(0, 9)).direction_to(GameManager.player.global_position)
	newHead.speed = 230 * 1.2
	newHead.damage = 1
	newHead.lifetime = .7
	newHead.global_position = global_position - Vector2(0, 18)
	GameManager.spawnManager.spawn_object(newHead)
	var _discard = newHead.connect("tree_exited", self, "wander")


func update_healthbar():
	hpBar.max_value = healthManager.maxHealth
	hpBar.value = healthManager.health
