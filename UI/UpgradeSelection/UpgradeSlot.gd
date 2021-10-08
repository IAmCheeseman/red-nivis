tool
extends Control

onready var textureRect = $BG/TextureRect
onready var bg = $BG


export var upgrade:Resource = preload("res://Items/Upgrades/DoubleJump/DoubleJump.tres") setget update_upgrade

signal clicked


func _ready() -> void:
	textureRect.texture = upgrade.icon


func _gui_input(event: InputEvent) -> void:
	bg.self_modulate = Color(0, 0, 0, .5)
	if event.is_action_pressed("use_item"):
		emit_signal("clicked")
		bg.self_modulate = Color(0, 0, 0, .75)

func update_upgrade(_upgrade:Upgrade) -> void:
	upgrade = _upgrade
	if is_inside_tree():
		textureRect.texture = upgrade.icon
