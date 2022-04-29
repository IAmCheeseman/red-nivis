extends Control

onready var textureRect = $BG/TextureRect
onready var bg = $BG
onready var nameLabel = $Name


export var upgrade:Resource = preload("res://Items/Upgrades/DoubleJump/DoubleJump.tres") setget update_upgrade

signal clicked


func _ready() -> void:
	textureRect.texture = upgrade.icon
	nameLabel.text = upgrade.name
	
	nameLabel.modulate = Color("#c7cfcc")


func _gui_input(event: InputEvent) -> void:
	bg.self_modulate = Color(0, 0, 0, .5)
	if event.is_action_pressed("use_item"):
		emit_signal("clicked")
		bg.self_modulate = Color(0, 0, 0, .75)
		nameLabel.modulate = Color("#c7cfcc")

func update_upgrade(_upgrade:Upgrade) -> void:
	upgrade = _upgrade
	if is_inside_tree():
		textureRect.texture = upgrade.icon
		nameLabel.text = upgrade.name

func _on_mouse_entered() -> void:
	rect_position.y -= 1
	rect_size.y += 1
	nameLabel.modulate = Color("#e8c170")

func _on_mouse_exited() -> void:
	rect_position.y += 1
	rect_size.y -= 1
	nameLabel.modulate = Color("#c7cfcc")
