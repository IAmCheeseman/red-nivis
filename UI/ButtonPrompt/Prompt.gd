tool
extends MarginContainer

export var promptText := "[Action]" setget _on_prompt_text_changed
export var promptAction := "interact" setget _on_prompt_action_changed


func _ready() -> void:
	_on_prompt_action_changed(promptAction)


func _on_prompt_text_changed(val: String) -> void:
	promptText = val
	yield(TempTimer.idle_frame(self), "timeout")
	$Content/Label.text = promptText

func _on_prompt_action_changed(val: String) -> void:
	promptAction = val
	if !InputMap.has_action(val): return
	var inputEvent: InputEvent = InputMap.get_action_list(val)[0]
	var text = "%s_KB.png" % inputEvent.as_text()
	yield(TempTimer.idle_frame(self), "timeout")
	$Content/TextureRect.texture = load("res://UI/Assets/Prompts/%s" % text)
