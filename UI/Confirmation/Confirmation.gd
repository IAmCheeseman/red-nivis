extends CenterContainer

onready var _textLabel = $VBoxContainer/Label
onready var _buttons = $VBoxContainer/HBoxContainer


export var text := "Empty prompt"
export(Array, String) var options := [
	"YES",
	"NO"
]
export(Array, String) var negativeOptions := [
	"NO"
]

signal optionPressed(option)

func _ready() -> void:
	hide()
	
	_textLabel.text = text
	
	var button = _buttons.get_child(0).duplicate()
	Utils.free_children(_buttons)
	for i in options:
		var newButton = button.duplicate()
		newButton.text = i
		newButton.isNegative = i in negativeOptions
		newButton.connect("pressed", self, "_on_button_pressed", [i])
		_buttons.add_child(newButton)

func _on_button_pressed(button: String) -> void:
	emit_signal("optionPressed", button)
	hide()
