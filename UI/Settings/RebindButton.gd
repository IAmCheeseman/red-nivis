extends Button

export(String) var action
export var actionDisplay: String = ""

var _editing = false
var defaultBind: InputEvent
var currentBindAsText: String


func _ready():
	_update_button_text(InputMap.get_action_list(action)[0])
	focus_mode = Control.FOCUS_NONE
	
	var _discard = Settings.connect("lang_changed", self, "_on_language_changed")


func _input(inputEvent: InputEvent) -> void:
	if inputEvent.is_action_pressed("pause"): return
	if inputEvent is InputEventGesture: return
	if inputEvent is InputEventJoypadMotion: return
	
	if _editing and !inputEvent is InputEventMouseMotion:
		get_tree().set_input_as_handled()
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, inputEvent)
		Settings.keybinds[action] = inputEvent.as_text()
		print(inputEvent.as_text())
		_update_button_text(inputEvent)
		_editing = false
		pressed = false


func _update_button_text(inputEvent: InputEvent) -> void:
	if inputEvent is InputEventMouseButton:
			match inputEvent.button_index:
				BUTTON_LEFT:
					text = "%s: LMB" % tr(actionDisplay)
					currentBindAsText = "LMB"
				BUTTON_RIGHT:
					text = "%s: RMB" % tr(actionDisplay)
					currentBindAsText = "RMB"
				BUTTON_MIDDLE:
					text = "%s: MMB" % tr(actionDisplay)
					currentBindAsText = "MMB"
				BUTTON_XBUTTON2:
					text = "%s: MB4" % tr(actionDisplay)
					currentBindAsText = "MB4"
				BUTTON_XBUTTON1:
					text = "%s: MB5" % tr(actionDisplay)
					currentBindAsText = "MB5"
	else:
		text = "%s: %s" % [tr(actionDisplay), inputEvent.as_text()]
		currentBindAsText = inputEvent.as_text()


func _on_language_changed() -> void:
	text = "%s: %s" % [tr(actionDisplay), currentBindAsText]


func reset() -> void:
	var defaultKey = Settings.defaultKeybinds[action]
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, defaultKey)
	Settings.keybinds[action] = defaultKey.as_text()
	_update_button_text(defaultKey)


func _on_rebind() -> void:
	_editing = true
	text = "Hit a key"
