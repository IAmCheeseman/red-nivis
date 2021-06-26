extends Button

export var menu:NodePath


func _ready():
	focus_mode = Control.FOCUS_NONE


func _on_pressed():
	get_parent().visible = false
	get_node(menu).visible = true
