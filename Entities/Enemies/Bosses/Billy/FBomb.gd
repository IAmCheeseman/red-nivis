extends KinematicBody2D

onready var sprite = $Sprite
onready var rc = $RayCast2D
onready var anim = $AnimationPlayer

var vel := Vector2(0, -200)

func _physics_process(delta: float) -> void:
	sprite.rotation += delta * 2
	vel.y += Globals.GRAVITY * delta
	
	if rc.is_colliding():
		anim.play("Exlpode")
	
	vel.y = move_and_slide(vel).y
