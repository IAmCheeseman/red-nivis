extends Control

onready var itemName = $ItemName
onready var itemAmount = $ItemAmount

var item:String

signal hovering
signal move


func setup(name_:String, amount:int, itemID:String):
	itemName.text = " %s" % name_
	itemAmount.text = "x%s " % amount
	item = itemID


func _on_press():
	emit_signal("move", self)


func _on_mouse_entered():
	emit_signal("hovering", self)