extends Control

onready var BG = $BG

export var useable = true


func _ready():
	hide()
	if !useable: queue_free()


func _input(event):
	if event.is_action_pressed("pause") and !GameManager.inGUI:
		pause(!visible)


func pause(on: bool) -> void:
	visible = on
	$Margin.visible = visible
	get_tree().paused = visible
	VisualServer.set_shader_time_scale(int(!visible))


func _on_continue_pressed():
	hide()
	get_tree().paused = false
	VisualServer.set_shader_time_scale(1)


func _on_quittm_pressed():
	Resetter.reset()
	GameManager.save_game()
	GameManager.save_run()
	get_tree().paused = false
	VisualServer.set_shader_time_scale(1)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")

