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
	slotTexture.material = slotTexture.material.duplicate()

	#slotTexture.material = slotTexture.material.duplicate()


func setup(texture, itemID:String):
	slotTexture.texture = texture
	item = itemID
	var i = ItemMap.ITEMS[item]
	slotTexture.material.set_shader_param(
		"line_color", Color(ToolTipGenerator.TIER_COLORS[i.tier]))
	tooltip = ToolTipGenerator.tooltips(i.name, i.tier)
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


func _process(_delta: float) -> void:
	var rect = get_global_rect()
	if rect.has_point(get_global_mouse_position()):
		_on_mouse_entered()
	else:
		_on_mouse_exited()


func _on_press():
	return
# warning-ignore:unreachable_code
	emit_signal("selected", self)


func _on_mouse_entered() -> void:
	ToolTip.set_tooltip(tooltip)
	ToolTip.id = item


func _on_mouse_exited() -> void:
	if ToolTip.id == item:
		ToolTip.id = ""
		ToolTip.set_tooltip("")
