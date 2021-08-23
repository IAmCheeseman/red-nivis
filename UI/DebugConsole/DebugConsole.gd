extends Control

onready var input = $CenterContainer/VBoxContainer/Input
onready var output = $CenterContainer/VBoxContainer/Output
onready var definitions = $CommandsDefinitions


func process_command(command:String):
	var words = command.split(" ")
	words = Array(words)
	for _w in range(words.count("")):
		words.erase("")

	if words.size() == 0:
		output_text("ERROR: No command provided.")
		return

	var commandWord = words.pop_front()

	if commandWord == "clear":
		output.text = "Debug Console\nDebug console has been cleared."
		return

	var commandKeys = definitions.VALID_COMMANDS.keys()
	for c in commandKeys:
		if c == commandWord:
			var commandArgs = definitions.VALID_COMMANDS[c]
			# Check if all the arguments are correct
			if words.size() != commandArgs.size():
				output_text("ERROR: Command expected %s arguments. You gave %s." % [commandArgs.size(), words.size()])
				return

			for i in words.size():
				if !check_type(words[i], commandArgs[i]):
					output_text("ERROR: failed to execute command: '%s'. Parameter '%s' is incorrect." % [c, words[i]])
					return
				words[i] = convert_type(words[i], commandArgs[i])
			# Executing the command
			output_text(definitions.callv(commandWord, words))
			return
	output_text("ERROR: Command '%s' does not exist. Use \"help\"." % [commandWord])


func check_type(string:String, type:int):
	match type:
		definitions.ARG_INT:
			return string.is_valid_integer()
		definitions.ARG_FLOAT:
			return string.is_valid_float()
		definitions.ARG_STR:
			return true
		definitions.ARG_BOOL:
			return (string == "true" or string == "false")
	return false


func convert_type(string:String, type:int):
	match type:
		definitions.ARG_INT:
			return int(string)
		definitions.ARG_FLOAT:
			return float(string)
		definitions.ARG_STR:
			return string
		definitions.ARG_BOOL:
			var returnValue = true if string == "true" else false
			return returnValue


func output_text(text:String):
	output.text += "\n"+text
	output.set_v_scroll(output.scroll_vertical+1000)


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




