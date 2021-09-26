extends "res://UI/DebugConsole/Commands.gd"

onready var input = $CenterContainer/VBoxContainer/Input
onready var output = $CenterContainer/VBoxContainer/Output
onready var definitions = $CommandsDefinitions


func process_command(command:String):
	var expression = Expression.new()
	var error = expression.parse(command, [])
	if error != OK:
		print(expression.get_error_text())
		return
	var result = expression.execute([], self, true)
	if not expression.has_execute_failed():
		output_text(str(result))


func output_text(text:String):
	output.text += "\n"+text
	output.set_v_scroll(output.scroll_vertical+1000)


func clear() -> String:
	output.text = ""
	return ""


func _on_input_text_entered(new_text):
	input.text = ""
	process_command(new_text)


func _on_input_text_changed(new_text):
	if new_text == "`": input.text = ""


func _on_hide_button_pressed():
	hide()
	get_tree().paused = false


func _input(event):
	if event.is_action_pressed("debug_console"):
		visible = !visible
		input.grab_focus()
		get_tree().paused = visible




