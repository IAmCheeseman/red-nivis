extends OptionButton
class_name CustomOptionButton

export(Array, String) var options = ["Default"]
export var defaultIndex: int = 0

var label = text

func _ready() -> void:
	flat = true
	focus_mode = Control.FOCUS_NONE
	
	connect("item_selected", self, "_on_new_item_selected")
	
	for i in options:
		add_item(i)
	
	select(defaultIndex)
	
	_on_new_item_selected(defaultIndex)


func _on_new_item_selected(idx: int) -> void:
	text = "%s: %s" % [label, get_item_text(idx)]
