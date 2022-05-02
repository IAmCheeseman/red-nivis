extends Control

onready var upgrades = find_node("Upgrades")
onready var selections = find_node("Selections")
onready var slotsLeftLabel = find_node("SlotsLeft")

var player = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	for u in upgrades.get_children():
		if u is Label: continue
		if !u.upgrade.resource_path in player.unlockedUpgrades:
			u.queue_free()
			continue
		u.connect("clicked", self, "_on_upgrade_slot_clicked", [u])
	slotsLeftLabel.text = "Slots Left: %s" % str(player.upgradeSlots)


func init_slots() -> void:
	for i in upgrades.get_children():
		if i is Label: continue
		var u = i.upgrade
		if u in player.upgrades: _on_upgrade_slot_clicked(i)


func _on_upgrade_slot_clicked(node: Node) -> void:
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
	player.upgrades.clear()
	for s in selections.get_children():
		if s is Label: continue
		player.upgrades.append(s.upgrade.resource_path)
	GameManager.inGUI = false
	player.emit_signal("updateAbilities")
	hide()

