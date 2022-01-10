extends Node2D

enum {ATTACK=3}

onready var sprite = $Sprite
onready var attackTimer = $AttackTimer
onready var b = get_parent()

var player: Node2D

const ARM_POSITIONS := [Vector2(2, -12), Vector2(-2, -12)]

var prevRot := 0.0

var laser = preload("res://Entities/Enemies/Bandit/Laser/Laser.tscn")
var shot = false


func _process(delta: float) -> void:
	if !player: return
	
	if b.state == ATTACK:
		visible = b.anim.current_animation == "Attack"
		var anim = "WindUp" if b.anim.current_animation != "Attack" else "Attack"
		b.idle_state(delta, anim)
		if b.anim.current_animation in ["WindUp", "Attack"]: 
			b.state = ATTACK
	else:
		hide()
	
	look_at(player.global_position-Vector2(0, 8))
	sprite.flip_v = Vector2.RIGHT.rotated(rotation).x < 0
	position = ARM_POSITIONS[int(sprite.flip_v)]
	position.x *= get_parent().sprite.scale.x
	
	var weight = 25 * delta
	weight *= global_position.distance_to(player.global_position) / 150
	global_rotation = lerp_angle(prevRot, global_rotation, weight)
	
	prevRot = global_rotation


func shoot() -> void:
	var newLaser = laser.instance()
	newLaser.global_position = global_position
	GameManager.spawnManager.add_child(newLaser)
	yield(TempTimer.idle_frame(self), "timeout")
	newLaser.look_at(newLaser.position+Vector2.RIGHT.rotated(rotation))


func _on_attack_timer_timeout() -> void:
	b.state = ATTACK if b.state != ATTACK else b.IDLE
	attackTimer.start(rand_range(1, 2))
