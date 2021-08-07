extends Control

onready var slotTexture = $TextureRect
onready var indexLabel = $Index

var item:String

signal selected(button)


func _ready():
	update_index()
	set_focus_mode(Control.FOCUS_CLICK)


func setup(texture:StreamTexture, itemID:String):
	slotTexture.texture = texture
	item = itemID
	update_index()


func clear():
	slotTexture.texture = null
	update_index()
	item = ""


func update_index():
	indexLabel.text = str(get_index()+1)


func _on_press():
	emit_signal("selected", self)
