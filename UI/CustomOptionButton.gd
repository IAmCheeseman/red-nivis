extends Button
class_name CustomOptionButton


export(Array, String) var options := []

export var selectedIdx := 0
var selected := ""

var _originalPosition: Vector2 
var _originalText: String
var hovering := false


func _ready() -> void:
	var _discard0 = connect("mouse_entered", self, "_on_mouse_entered")
	var _discard1 = connect("mouse_exited", self, "_on_mouse_exited")
	var _discard2 = connect("pressed", self, "_on_pressed")
	
	theme = Theme.new()
	theme.set_color("font_color", "Button", Color("#c7cfcc"))
	theme.set_color("font_color_hover", "Button", Color("#e8c170"))
	theme.set_color("font_color_pressed", "Button", Color("#de9e41"))
	
	_originalPosition = rect_position
	_originalText = text
	
	focus_mode = Control.FOCUS_NONE
	flat = true
	
	update_button()


func update_button() -> void:
	selected = options[selectedIdx]
	text = "%s: %s >" % [_originalText, selected]
	yield(TempTimer.idle_frame(self), "timeout")
	_on_mouse_entered()


func _on_mouse_entered() -> void:
	rect_position = _originalPosition+Vector2.UP


func _on_mouse_exited() -> void:
	rect_position = _originalPosition


func _on_pressed() -> void:
	selectedIdx = wrapi(selectedIdx + 1, 0, options.size())
	update_button()
