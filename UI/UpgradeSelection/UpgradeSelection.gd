extends Control

onready var upgrades = find_node("Upgrades")
onready var selections = find_node("Selections")
onready var slotsLeftLabel = find_node("SlotsLeft")

var player = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	for u in upgrades.get_children():
		u.connect("clicked", self, "_on_upgrade_slot_clicked", [u])
	slotsLeftLabel.text = "Slots Left: %s" % str(player.upgradeSlots)


func _on_upgrade_slot_clicked(node:Node) -> void:
	if node.get_parent() == upgrades:
		if selections.get_child_count() == player.upgradeSlots:
			return
		upgrades.remove_child(node)
		selections.add_child(node)
	else:
		selections.remove_child(node)
		upgrades.add_child(node)
	slotsLeftLabel.text = "Slots Left: %s" % str(player.upgradeSlots-selections.get_child_count())


func _on_done_pressed():
	for s in selections.get_children():
		player.upgrades.append(s.upgrade.abilityScript)
	var _discard = get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")

