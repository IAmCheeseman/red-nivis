extends KinematicBody2D
class_name EnemyBullet

var direction : Vector2
var speed : float
var peircing = false
onready var lastFramePos = global_position

onready var hitbox = $Hitbox

func _physics_process(delta):
	global_position = lastFramePos
	global_position += (direction*speed)*delta
	lastFramePos = global_position


func _on_QueueArea_body_entered(_body):
	queue_free()


func _on_Hitbox_hit_object():
	if !peircing:
		queue_free()
