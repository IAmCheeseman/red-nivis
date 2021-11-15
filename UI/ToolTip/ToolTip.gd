extends Node2D
class_name Tooltip

const MOUSE_OFFSET = Vector2(7, 6)
const PADDING = 4

onready var label = $Label
onready var bg = $BG

var id: String


func _ready() -> void:
	set_tooltip("")


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	global_position -= bg.rect_size+MOUSE_OFFSET
	bg.rect_position = label.rect_position-Vector2.ONE*PADDING
	bg.rect_size = label.rect_size+Vector2(0, PADDING*2)


func set_tooltip(tooltip:String) -> void:
	if tooltip == "":
		hide()
	else:
		show()
		label.bbcode_text = tooltip.left(tooltip.find_last("\n"))
		
		var tt:String = label.text+"\n"
		
		var font:Font = label.get_font("bold_font")
		var longestLine = "b"
		for i in tt.count("\n"):
			var firstp = tt.find("\n")
			var nextp = tt.find("\n", firstp)
			
			var line := tt.left(firstp)
			line = line.right(nextp-line.length())
			
			tt = tt.right(firstp+1)
			
			if font.get_string_size(line).x\
			> font.get_string_size(longestLine).x:
				longestLine = line
		
		var size:int = font.get_string_size(longestLine).x+(PADDING*.5)
		label.rect_size.x = size
