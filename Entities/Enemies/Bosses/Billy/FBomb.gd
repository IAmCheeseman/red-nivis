extends KinematicBody2D

onready var sprite = $Sprite
onready var rc = $RayCast2D
onready var anim = $AnimationPlayer
onready var collider = $Hitbox/CollisionShape2D

var vel := Vector2.ZERO

func _ready() -> void:
	vel = global_position.direction_to(GameManager.player.global_position) * 300
	vel.y -= 200

func _physics_process(delta: float) -> void:
	sprite.rotation += delta * 2
	vel.y += Globals.GRAVITY * delta
	
	if rc.is_colliding():
		anim.play("Exlpode")
		update()
	
	vel.y = move_and_slide(vel).y

func _draw() -> void:
	if !sprite.visible: return
	var radius = collider.shape.radius
	draw_circle(Vector2.ZERO, radius + 8, Color(1, 0, 0, .25))
	draw_arc(Vector2.ZERO, radius + 8, 0, PI * 2, 22, Color.red, 2)
