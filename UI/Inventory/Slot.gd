extends Control

onready var slotTexture = $TextureRect

var item:String

signal hovering
signal move


func setup(texture:StreamTexture, itemID:String):
	slotTexture.texture = texture
	item = itemID


func clear():
	slotTexture.texture = null
	item = ""


func _on_press():
	emit_signal("move", self)


func _on_mouse_entered():
	emit_signal("hovering", self)
