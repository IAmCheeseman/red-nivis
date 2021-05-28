extends StaticBody2D

onready var animation = $AnimationPlayer

export var pressed = false

func _ready():
	if pressed:
		disappear()
	else:
		reappear()

func disappear():
	animation.play("Remove")
	pressed = true

func reappear():
	animation.play("Create")
	pressed = false


func toggle():
	if pressed: reappear()
	else: disappear()
