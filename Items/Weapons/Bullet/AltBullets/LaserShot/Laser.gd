extends Node2D

onready var laserLine = $LaserLine
onready var raycast = $RayCast
onready var light = $Light
onready var end = $End

var damage:int
var direction:Vector2
var speed
var player
var peircing
var lifetime

func _ready():
	raycast.cast_to = direction*1000
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is TileMap:
			raycast.cast_to = direction*position.distance_to(collider.position)
			raycast.force_raycast_update()

		if collider.is_in_group("hurtbox"):
			collider.take_damage(damage, raycast.cast_to.normalized())
	var collisionPoint = raycast.get_collision_point()-position
	if !raycast.is_colliding(): collisionPoint = raycast.cast_to

	laserLine.clear_points()
	laserLine.add_point(Vector2.ZERO)
	laserLine.add_point(collisionPoint)
	end.position = collisionPoint
	light.scale.x = collisionPoint.length()*.125
	light.rotation = collisionPoint.angle()
