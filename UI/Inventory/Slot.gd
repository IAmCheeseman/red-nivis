extends Control

onready var slotTexture = $TextureRect

var item: String

# warning-ignore:unused_signal
signal selected(button)


func _ready():
	set_focus_mode(Control.FOCUS_CLICK)
	slotTexture.material = slotTexture.material.duplicate()


func setup(texture, itemID:String):
	slotTexture.texture = load(texture)
	item = itemID
	#var i = ItemMap.ITEMS[item]

#	slotTexture.material.set_shader_param(
#		"line_color", Color(ToolTipGenerator.TIER_COLORS[i.tier]))


func clear():
	slotTexture.texture = null
	item = ""

