extends Control

onready var upgrades = find_node("Upgrades")
onready var selections = find_node("Selections")

func _ready() -> void:
	for i in upgrades.get_children():
		i.connect("clicked", self, "_on_upgrade_slot_clicked", [i])


func _on_upgrade_slot_clicked(node:Node) -> void:
	if node.get_parent() == upgrades:
		upgrades.remove_child(node)
		selections.add_child(node)
	else:
		selections.remove_child(node)
		upgrades.add_child(node)


func _on_selection_slot_clicked() -> void:
	pass

