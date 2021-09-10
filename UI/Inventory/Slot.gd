extends Control

onready var slotTexture = $TextureRect
onready var indexLabel = $Index
onready var weaponHolder = $WeaponHolder

var item:String

signal selected(button)


func _ready():
	update_index()
	set_focus_mode(Control.FOCUS_CLICK)

	#slotTexture.material = slotTexture.material.duplicate()


func setup(texture, itemID:String, outlineColor:Color=Color.white):
	if texture is Node2D:
		weaponHolder.add_child(texture.duplicate())
	else:
		slotTexture.texture = texture
		slotTexture.material.set_shader_param("line_color", outlineColor)
	item = itemID
	update_index()


func clear():
	if slotTexture.get_child_count() > 0:
		slotTexture.get_child(0).queue_free()
	slotTexture.texture = null
	for i in weaponHolder.get_children(): i.queue_free()
	update_index()
	item = ""


func update_index():
	indexLabel.text = str(get_index()+1)


func _on_press():
	emit_signal("selected", self)
