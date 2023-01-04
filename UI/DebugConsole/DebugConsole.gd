extends "res://UI/DebugConsole/Commands.gd"

onready var input = $VBoxContainer/Input
onready var output = $VBoxContainer/Output


func process_command(command:String):
	if command == "": return
	
	var args := command.split(" ")
	
	var gdCommand = args[0] + "("
	args.remove(0)
	for i in args:
		gdCommand += i + ","
	gdCommand += ")"
	print(gdCommand)
	
	var expression = Expression.new()
	var error = expression.parse(gdCommand, [])
	if error != OK:
		output_text(expression.get_error_text())
		return
	var result = expression.execute([], self, false)
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


func _input(event):
	if event.is_action_pressed("debug_console") and !OS.has_feature("standalone"):
		visible = !visible
		input.grab_focus()
		get_tree().paused = visible
		yield(TempTimer.idle_frame(self), "timeout")
		input.text = ""




