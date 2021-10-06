extends Node2D

onready var shopInterface = $CanvasLayer
onready var shopGUI = $CanvasLayer/ShopInterface


func _ready() -> void:
	for i in shopInterface.get_children(): i.hide()


func show_gui() -> void:
	for i in shopInterface.get_children(): i.show()
	GameManager.inGUI = true
	shopGUI.update_slots()


func _on_exit_pressed() -> void:
	for i in shopInterface.get_children(): i.hide()
	GameManager.inGUI = false
