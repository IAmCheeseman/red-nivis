extends Control

onready var landscape = $Landscape
onready var space = $Space
onready var options = $CanvasLayer/OptionsMenu
onready var buttons = $CanvasLayer/Buttons



func _ready():
	var buttonContainer = $CanvasLayer/Buttons
	for c in buttonContainer.get_children():
		c.set_focus_mode(Control.FOCUS_NONE)

	randomize()
# warning-ignore:narrowing_conversion
	var useLandscape = bool(round(rand_range(0, 1)))
	if useLandscape: landscape.queue_free()
	else: space.queue_free()



func _on_Quit_pressed():
	get_tree().quit()


func _on_Play_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Space/Space.tscn")


func _on_Feedback_pressed():
# warning-ignore:return_value_discarded
	OS.shell_open("https://forms.gle/Fi7mr6HH6zgAHs4e8")


func _on_Options_pressed():
	buttons.hide()
	options.show()
