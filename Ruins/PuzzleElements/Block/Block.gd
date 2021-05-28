extends StaticBody2D

onready var animation = $AnimationPlayer

func disappear():
	animation.play("Remove")
