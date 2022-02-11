extends Control

onready var BG = $BG
onready var BGgradient = $BG/Gradient

export var useable = true


func _ready():
	hide()
	if !useable: queue_free()


func _process(_delta: float) -> void:
	BGgradient.rect_position.x = BG.rect_position.x + BG.rect_size.x


func _input(event):
	if event.is_action_pressed("pause") and !GameManager.inGUI:
		visible = !visible
		$CenterContainer.visible = visible
		get_tree().paused = visible
		VisualServer.set_shader_time_scale(int(!visible))


func _on_continue_pressed():
	hide()
	get_tree().paused = false
	VisualServer.set_shader_time_scale(1)


func _on_quittm_pressed():
	Resetter.reset()
	get_tree().paused = false
	GameManager.clear_run()
	VisualServer.set_shader_time_scale(1)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")


func _on_quittd_pressed():
	get_tree().quit()
