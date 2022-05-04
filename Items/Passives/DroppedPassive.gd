extends RigidBody2D

onready var sprite=  $Sprite

export var item: Resource


func _ready() -> void:
	sprite.texture = item.sprite
