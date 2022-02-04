extends KinematicBody2D

const SPIDER = preload("res://Entities/Enemies/TinySpider/TinySpider.tscn")
const MAX_SPIDERS = 12

enum { WANDER, ATTACK }

onready var sprite := $Sprite
onready var anim := $AnimationPlayer

onready var spiderSpawn := $Sprite/SpiderSpawn

onready var walkTimer := $Timers/Walk
onready var attackCooldown := $Timers/Attack

export var frict := 20
export var speed := 90
export var attackTimeRange := Vector2(1, 2)

var state := WANDER

var vel := Vector2.ZERO
var target := 0

var spiders := []


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
	target = GameManager.player.global_position.x + rand_range(-128, 128)
	if Utils.coin_flip(): target = global_position.x
	walkTimer.start(rand_range(1, 4))


func spawn_spiders() -> void:
	for i in 3:
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
	if spiders.size() + 3 > MAX_SPIDERS:
		wander()
		return
	anim.play("DropSpiders")
	state = ATTACK
