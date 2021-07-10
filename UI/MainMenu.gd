extends Control

onready var options = $CanvasLayer/OptionsMenu
onready var buttons = $CanvasLayer/Buttons
onready var anim = $AnimationPlayer


func _ready():
	var buttonContainer = $CanvasLayer/Buttons
	for c in buttonContainer.get_children():
		c.set_focus_mode(Control.FOCUS_NONE)
	randomize()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Play_pressed():
	anim.play("FadeAway")


func play_game():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Space/Space.tscn")


func _on_Feedback_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://forms.gle/Fi7mr6HH6zgAHs4e8")


func _on_Options_pressed():
	buttons.hide()
	options.show()

