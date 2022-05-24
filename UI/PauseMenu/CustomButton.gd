extends Button
class_name CustomButton

export var isNegative := false
export var fromPth: NodePath
export var toPth: NodePath

var _originalPosition: Vector2
var hovering := false

var focused := false


func _ready() -> void:
	var _discard0 = connect("mouse_entered", self, "_on_mouse_entered")
	var _discard1 = connect("mouse_exited", self, "_on_mouse_exited")
	var _discard2 = connect("pressed", self, "change_menu")

	theme = Theme.new()
	if isNegative:
		theme.set_color("font_color", "Button", Color("#a53030"))
		theme.set_color("font_color_focus", "Button", Color("#a53030"))
		theme.set_color("font_color_hover", "Button", Color("#cf573c"))
		theme.set_color("font_color_pressed", "Button", Color("#752438"))
	else:
		theme.set_color("font_color", "Button", Color("#c7cfcc"))
		theme.set_color("font_color_focus", "Button", Color("#c7cfcc"))
		theme.set_color("font_color_hover", "Button", Color("#e8c170"))
		theme.set_color("font_color_pressed", "Button", Color("#de9e41"))
	theme.set_stylebox("focus", "Button", StyleBoxEmpty.new())

	_originalPosition = rect_position
	flat = true


func set_focused(val: bool) -> void:
	if val and !focused:
		_on_mouse_entered()
		focused = val
	elif !val and focused:
		_on_mouse_exited()
		focused = val


func _on_mouse_entered() -> void:
	rect_position.y -= 1
	rect_size.y += 1
	focused = true

func _on_mouse_exited() -> void:
	rect_position.y += 1
	rect_size.y -= 1
	focused = false


func change_menu() -> void:
	if !has_node(fromPth) or !has_node(toPth): return
	get_node(fromPth).hide()
	get_node(toPth).show()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	if !focused: return
	
	var toNode: NodePath = get_path()
	if event.is_action_pressed("ui_down"): toNode = focus_neighbour_bottom
	elif event.is_action_pressed("ui_up"): toNode = focus_neighbour_top
	elif event.is_action_pressed("ui_left"): toNode = focus_neighbour_left
	elif event.is_action_pressed("ui_right"): toNode = focus_neighbour_right
	
	if !has_node(toNode) or toNode == null: return
	
	set_focused(false)
	var node = get_node(toNode)
	if !node.focused: node.set_focused(true)
	

