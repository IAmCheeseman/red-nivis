extends Control

const MOUSE_OFFSET = Vector2(7, 6)

onready var label = $Label
onready var bg = $BG


func _ready() -> void:
	set_tooltip("Spgahetti\nDMG: 12\nAccuracy: 15\nsdfusdkjdfsdfsasdasdasdad\n")


func _process(delta: float) -> void:
	rect_global_position = get_global_mouse_position()
	rect_global_position -= bg.rect_size+MOUSE_OFFSET


func set_tooltip(tooltip:String) -> void:
	if tooltip == "":
		hide()
	else:
		show()
		label.bbcode_text = tooltip
		
		var font:Font = label.get_font("normal_font")
		var longestLine = "b"
		for i in tooltip.count("\n"):
			var firstp = tooltip.find("\n")
			var nextp = tooltip.find("\n", firstp)
			
			var line := tooltip.left(firstp)
			line = line.right(nextp-line.length())
			
			tooltip = tooltip.right(firstp+1)
			
			if font.get_string_size(line).x\
			> font.get_string_size(longestLine).x:
				longestLine = line
		
		var size:int = font.get_string_size(longestLine).x+16
		label.rect_size.x = size
		bg.rect_size = Vector2(size, label.rect_size.y)
