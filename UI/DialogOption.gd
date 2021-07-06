extends Button


signal optionSelected


func set_option(optionText:String):
	text = optionText


func _on_Button_pressed():
	emit_signal("optionSelected", text)
