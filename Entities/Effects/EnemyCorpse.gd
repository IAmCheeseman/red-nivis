extends RigidBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D

var isReady = false

func _ready() -> void:
	isReady = true

func set_sprite(texture: StreamTexture) -> void:
	if !isReady: yield(TempTimer.idle_frame(self), "timeout")
	
	sprite.texture = texture
	
	var width := texture.get_width()
	var height := texture.get_height()
	
	var radius := width if width < height else height
	radius /= 2.5
	var shape := CircleShape2D.new()
	shape.radius = radius
	collision.shape = shape
