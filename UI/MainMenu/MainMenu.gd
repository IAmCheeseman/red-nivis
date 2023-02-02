extends Node2D


onready var camera := $Camera2D

var camStart: Vector2

func _ready() -> void:
	MusicManager.set_music(preload("res://World/EnviormentalArt/Lab/LabAmbience.ogg"))

func _process(_delta: float) -> void:
	camera.position = get_local_mouse_position() * .1

func quit() -> void:
	get_tree().quit()