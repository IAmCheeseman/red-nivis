extends MarginContainer

export var promptText := "[Action]" setget _on_prompt_text_changed
export var promptAction := "interact"

var doneAction := false

func _enter_tree() -> void:
	_on_prompt_action_changed()


func _on_prompt_text_changed(val: String) -> void:
	promptText = val
	yield(TempTimer.idle_frame(self), "timeout")
	$Content/Label.text = promptText

func _on_prompt_action_changed() -> void:
	if doneAction: return
	doneAction = true
	
	for i in $Content.get_children():
		if !i.name in ["TextureRect", "Label"]: i.queue_free()
	
	var actions = promptAction.split(",")
	for i in actions:
		if !InputMap.has_action(i): continue
		var newButton = $Content/TextureRect.duplicate()
		
		var inputEvent: InputEvent = InputMap.get_action_list(i)[0]
		var text = "%s_kb.tres" % inputEvent.as_text().to_lower()
		
		newButton.texture = load("res://UI/Assets/Prompts/%s" % text)
		newButton.show()
		$Content.add_child_below_node($Content/TextureRect, newButton)
