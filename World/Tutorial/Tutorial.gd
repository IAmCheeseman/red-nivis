extends Node2D


func _ready() -> void:
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	yield(TempTimer.idle_frame(self), "timeout")
	inventory.remove_item(0)
