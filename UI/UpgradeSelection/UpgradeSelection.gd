extends Control

onready var upgrades = find_node("Upgrades")
onready var selections = find_node("Selections")

var player = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	for u in upgrades.get_children():
		u.connect("clicked", self, "_on_upgrade_slot_clicked", [u])


func _on_upgrade_slot_clicked(node:Node) -> void:
	if node.get_parent() == upgrades:
		upgrades.remove_child(node)
		selections.add_child(node)
	else:
		selections.remove_child(node)
		upgrades.add_child(node)


func _on_done_pressed():
	for s in selections.get_children():
		player.upgrades.append(s.upgrade.abilityScript)

