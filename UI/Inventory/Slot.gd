extends Control

onready var slotTexture = $TextureRect

var item:String

signal selected(button)


func setup(texture:StreamTexture, itemID:String):
	slotTexture.texture = texture
	item = itemID


func clear():
	slotTexture.texture = null
	item = ""

func _on_press():
	emit_signal("selected", self)
