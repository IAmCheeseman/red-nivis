extends KinematicBody2D

var direction : Vector2
var speed : float
var peircing = false

onready var hitbox = $Hitbox
onready var sprite = $Sprite


func set_texture(texture, lightTexture):
	sprite.texture = texture


func _ready():
	look_at(global_position+direction)


func _physics_process(delta):
	position += (direction*speed)*delta


func _on_QueueArea_body_entered(_body):
	queue_free()


func _on_Hitbox_hit_object():
	if !peircing:
		queue_free()
