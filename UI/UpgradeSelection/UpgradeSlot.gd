tool
extends Control

onready var textureRect = $BG/TextureRect
onready var bg = $BG


export var texture:StreamTexture = preload("res://Items/Upgrades/DoubleJump/DoubleJumpUpgrade.png") setget set_texture

signal clicked


func _ready() -> void:
	textureRect.texture = texture


func _gui_input(event: InputEvent) -> void:
	bg.color = Color(0, 0, 0, .5)
	if event.is_action_pressed("use_item"):
		emit_signal("clicked")
		bg.color = Color(0, 0, 0, .75)

func set_texture(tex:StreamTexture) -> void:
	texture = tex
	if is_inside_tree():
		textureRect.texture = texture
