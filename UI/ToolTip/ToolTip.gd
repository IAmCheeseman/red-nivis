extends Node2D
class_name Tooltip

const MOUSE_OFFSET = Vector2(4, 0)
const PADDING = 8

onready var label = $Label
onready var bg = $BG

var id: String


func _ready() -> void:
	set_tooltip("")


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	global_position -= label.rect_size-MOUSE_OFFSET
#	bg.rect_position = label.rect_position-Vector2.ONE*PADDING
#	bg.rect_size = label.rect_size+Vector2(0, PADDING*3)
#	label.rect_position = bg.rect_position


func set_tooltip(tooltip:String) -> void:
	if tooltip == "":
		hide()
	else:
		show()
		label.bbcode_text = tooltip.replace("\n", "")
		
		var font:Font = label.get_font("bold_font")
		var size := font.get_string_size(
			label.text)+Vector2(0, PADDING*.5)
		label.rect_size = size
		bg.rect_size = size*1.5
