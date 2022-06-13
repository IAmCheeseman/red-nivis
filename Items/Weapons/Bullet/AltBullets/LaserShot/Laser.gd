extends Node2D

onready var laserLine = $LaserLine
onready var raycast = $RayCast
onready var end = $End
onready var sparks = $End/Sparks

var damage:int
var direction:Vector2
var speed
var player
var peircing
var lifetime

# warning-ignore:unused_signal
signal hit_wall
# warning-ignore:unused_signal
signal hit_enemy

func _ready():
	yield(TempTimer.idle_frame(self), "timeout")
	do_damage()


func do_damage() -> void:
	raycast.cast_to = direction*1000
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is TileMap:
			raycast.cast_to = direction*position.distance_to(raycast.get_collision_point())
			raycast.force_raycast_update()
	
		if collider.is_in_group("EnemyBullet"):
			raycast.add_exception(collider)
			do_damage()
			return
		if collider.is_in_group("hurtbox"):
			collider.take_damage(damage, raycast.cast_to.normalized())
	var collisionPoint = raycast.get_collision_point()-position
	if !raycast.is_colliding(): collisionPoint = raycast.cast_to

	laserLine.clear_points()
	laserLine.add_point(Vector2.ZERO)
	laserLine.add_point(collisionPoint)
	end.position = collisionPoint
	
	sparks.look_at(global_position)
	sparks.rotation += PI
	sparks.restart()
