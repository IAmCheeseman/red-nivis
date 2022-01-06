extends Button

export(String) var action
export var actionDisplay: String = ""

var _editing = false


func _ready():
	_update_button_text(InputMap.get_action_list(action)[0])
	focus_mode = Control.FOCUS_NONE


func _input(inputEvent: InputEvent) -> void:
	if inputEvent.is_action_pressed("pause"): return
	if inputEvent is InputEventGesture: return
	
	if _editing and !inputEvent is InputEventMouseMotion:
		get_tree().set_input_as_handled()
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, inputEvent)
		Settings.keybinds[action] = inputEvent.as_text()


		_update_button_text(inputEvent)
		_editing = false
		pressed = false


func _update_button_text(inputEvent: InputEvent) -> void:
	if inputEvent is InputEventMouseButton:
			if inputEvent.button_index == BUTTON_LEFT:
				text = "%s: LMB" % actionDisplay
			elif inputEvent.button_index == BUTTON_RIGHT:
				text = "%s: RMB" % actionDisplay
			elif inputEvent.button_index == BUTTON_MIDDLE:
				text = "%s: MMB" % actionDisplay
	else:
		text = "%s: %s" % [actionDisplay, inputEvent.as_text()]


func _on_rebind() -> void:
	_editing = true
	text = "Hit a key"
