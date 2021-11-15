extends Control

onready var slotTexture = $TextureRect
onready var indexLabel = $Index
onready var weaponHolder = $WeaponHolder

var item: String
var tooltip: String

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
	tooltip = ToolTipGenerator.tooltips(
		WeaponConstructor.new().generate_weapon(
			int(item)
		)
	)
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


func _process(delta: float) -> void:
	var rect = get_global_rect()
	rect.position.y -= rect_size.y
	if rect.has_point(get_global_mouse_position())\
	and ToolTip.id == item:
		_on_mouse_entered()
	else:
		_on_mouse_exited()


func _on_press():
	emit_signal("selected", self)


func _on_mouse_entered() -> void:
	ToolTip.set_tooltip(
		ToolTipGenerator.tooltips(
			WeaponConstructor.new().generate_weapon(
				int(item)
			)
		)
	)
	ToolTip.id = item


func _on_mouse_exited() -> void:
	if ToolTip.id == item:
		ToolTip.id = ""
		ToolTip.set_tooltip("")
