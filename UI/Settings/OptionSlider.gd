extends HBoxContainer

onready var label = $Label
onready var at = $At
onready var slider = $HSlider


export var optionName: String = "Unnamed"
export var maxedMsg := ""
export var displayAsPercentage: bool = true
export var maxValue := 100

signal value_changed(value)

func _ready() -> void:
	slider.max_value = maxValue
	label.text = optionName+":"
	at.rect_min_size.x = at.get_font("font").get_string_size("100%").x
	_on_value_changed(slider.value)


func _on_value_changed(value: float) -> void:
	slider.value = stepify(value, 2.0)
	if displayAsPercentage: at.text = ""+str(slider.value)+"%"
	else: at.text = str(slider.value)
	if slider.value == slider.max_value and maxedMsg != "": at.text = str(maxedMsg)
	var charsRemaining = 6-at.text.length()
	yield(TempTimer.idle_frame(self), "timeout")
	emit_signal("value_changed", value)
