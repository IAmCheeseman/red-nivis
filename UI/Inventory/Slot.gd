extends Control

onready var slotTexture = $TextureRect
onready var indexLabel = $Index

var item:String

signal selected(button)


func _ready():
	update_index()
	set_focus_mode(Control.FOCUS_CLICK)

	slotTexture.material = slotTexture.material.duplicate()


func setup(texture:StreamTexture, itemID:String, outlineColor:Color):
	slotTexture.texture = texture
	slotTexture.material.set_shader_param("line_color", outlineColor)
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
