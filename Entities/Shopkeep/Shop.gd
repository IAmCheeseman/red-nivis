extends Node2D

onready var shopInterface = $CanvasLayer
onready var shopGUI = $CanvasLayer/ShopInterface

var playerClose = false


func _ready() -> void:
	for i in shopInterface.get_children(): i.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and playerClose:
		for i in shopInterface.get_children(): i.show()
		GameManager.inGUI = true
		shopGUI.update_slots()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"): playerClose = true


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"): playerClose = false


func _on_exit_pressed() -> void:
	for i in shopInterface.get_children(): i.hide()
	GameManager.inGUI = false
