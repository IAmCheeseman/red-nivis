extends Control

onready var itemName = $ItemName
onready var itemAmount = $ItemAmount

signal hovering
signal move

func setup(name_:String, amount:int):
	itemName.text = " %s" % name_
	itemAmount.text = "x%s " % amount


func _on_press():
	emit_signal("move", self)


func _on_mouse_entered():
	emit_signal("hovering", self)