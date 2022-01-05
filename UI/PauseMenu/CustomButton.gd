extends Button
class_name CustomButton

export var isNegative := false
export var fromPth: NodePath
export var toPth: NodePath

var _originalPosition: Vector2 
var hovering := false


func _ready() -> void:
	var _discard0 = connect("mouse_entered", self, "_on_mouse_entered")
	var _discard1 = connect("mouse_exited", self, "_on_mouse_exited")
	var _discard2 = connect("pressed", self, "change_menu")
	
	theme = Theme.new()
	if isNegative:
		theme.set_color("font_color", "Button", Color("#a53030"))
		theme.set_color("font_color_hover", "Button", Color("#cf573c"))
		theme.set_color("font_color_pressed", "Button", Color("#752438"))
	else:
		theme.set_color("font_color", "Button", Color("#c7cfcc"))
		theme.set_color("font_color_hover", "Button", Color("#e8c170"))
		theme.set_color("font_color_pressed", "Button", Color("#de9e41"))
	
	_originalPosition = rect_position
	focus_mode = Control.FOCUS_NONE
	flat = true


func _on_mouse_entered() -> void:
	rect_position.y -= 1

func _on_mouse_exited() -> void:
	rect_position.y += 1

func change_menu() -> void:
	if !has_node(fromPth) or !has_node(toPth): return 
	get_node(fromPth).hide()
	get_node(toPth).show()

