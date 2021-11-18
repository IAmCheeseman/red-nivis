extends Button
class_name CustomButton

export var isNegative := false

var _originalPosition: Vector2 
var _originalText: String
var hovering := false


func _ready() -> void:
	var _discard0 = connect("mouse_entered", self, "_on_mouse_entered")
	var _discard1 = connect("mouse_exited", self, "_on_mouse_exited")
	
	theme = Theme.new()
	if isNegative:
		theme.set_color("font_color", "Button", Color("#a53030"))
		theme.set_color("font_color_hover", "Button", Color("#cf573c"))
		theme.set_color("font_color_pressed", "Button", Color("#752438"))
	else:
		theme.set_color("font_color", "Button", Color("#c7cfcc"))
		theme.set_color("font_color_hover", "Button", Color("#ebede9"))
		theme.set_color("font_color_pressed", "Button", Color("#a8b5b2"))
	
	_originalPosition = rect_position
	_originalText = text
	focus_mode = Control.FOCUS_NONE
	flat = true



func _on_mouse_entered() -> void:
	text = "> %s <" % _originalText
	var timer = get_tree().create_timer(.01)
	timer.connect(
		"timeout", self, "set",
		["rect_position", _originalPosition+Vector2.UP]
	)


func _on_mouse_exited() -> void:
	text = _originalText
	rect_position = _originalPosition

