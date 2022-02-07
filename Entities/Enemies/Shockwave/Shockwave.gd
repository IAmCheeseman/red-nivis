extends Node2D


onready var sprite = $Sprite
onready var lifetimeTimer = $Lifetime


export var lifeTime := 1.0
export var speed := 130


func _ready() -> void:
	lifetimeTimer.start(lifeTime)


func _physics_process(delta: float) -> void:
	var direction := Vector2(scale.x, 0)
	position += direction * speed * delta
	
	if lifetimeTimer.time_left != 0:
		sprite.frame = sprite.hframes - ceil(sprite.hframes * (lifetimeTimer.time_left / lifetimeTimer.wait_time))
	
	if lifetimeTimer.is_stopped():
		queue_free()


func _on_body_entered(_body: Node) -> void:
	queue_free()
