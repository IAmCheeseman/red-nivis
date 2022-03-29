extends Control

onready var anim = $AnimationPlayer


func _ready() -> void:
	yield(TempTimer.timer(self, .75), "timeout")
	anim.play("Flash")


func to_menu() -> void:
	var _discard = get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")
