extends StaticBody2D

onready var animation = $AnimationPlayer

var pressed = false

func disappear():
	animation.play("Remove")
	pressed = true

func reappear():
	animation.play("Create")
	pressed = false


func toggle():
	if pressed: reappear()
	else: disappear()
