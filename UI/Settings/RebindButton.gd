extends Button

export(String) var action
export var actionDisplay: String = ""

var _editing = false


func _ready():
	_update_button_text(InputMap.get_action_list(action)[0])
	focus_mode = Control.FOCUS_NONE


func _input(input_event: InputEvent) -> void:
	if input_event.is_action_pressed("pause"): return
	if input_event is InputEventGesture: return
	
	if _editing and not input_event is InputEventMouseMotion:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, input_event)
		Settings.keybinds[action] = input_event.as_text()


		_update_button_text(input_event)
		_editing = false
		pressed = false


func _update_button_text(input_event: InputEvent) -> void:
	if input_event is InputEventMouseButton:
			if input_event.button_index == BUTTON_LEFT:
				text = "%s: LMB" % actionDisplay
			elif input_event.button_index == BUTTON_RIGHT:
				text = "%s: RMB" % actionDisplay
			elif input_event.button_index == BUTTON_MIDDLE:
				text = "%s: MMB" % actionDisplay
	else:
		text = "%s: %s" % [actionDisplay, input_event.as_text()]


func _on_rebind() -> void:
	_editing = true
	text = "Hit a key"
