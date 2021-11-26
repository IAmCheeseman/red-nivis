extends HBoxContainer

onready var label = $Label
onready var at = $At
onready var slider = $HSlider


export var optionName: String = "Unnamed"


func _ready() -> void:
	label.text = optionName+":"
	at.rect_min_size.x = at.get_font("font").get_string_size("100%").x
	_on_value_changed(slider.value)


func _on_value_changed(value: float) -> void:
	slider.value = stepify(value, 2.0)
	at.text = ""+str(slider.value)+"%"
	var charsRemaining = 6-at.text.length()
	yield(TempTimer.idle_frame(self), "timeout")
