extends Node2D

onready var parrySign = $Props/ParrySign
onready var parrySignAnim = $Props/ParrySign/AnimationPlayer2


func _ready() -> void:
	GameManager.inGUI = false
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	yield(TempTimer.idle_frame(self), "timeout")
	inventory.remove_item(0)
	
	parrySign.connect("dialog_finished", parrySignAnim, "play", ["Disappear"])
