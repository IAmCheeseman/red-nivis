extends Node

var playerData = preload("res://Entities/Player/Player.tres")

func _ready() -> void:
	playerData.connect("updateAbilities", self, "add_abilities")
	add_abilities()


func add_abilities() -> void:
	Utils.free_children(self)
	playerData.emit_signal("updateGrenade", 15, false)
	for a in playerData.upgrades:
		var newAbility = Node.new()
		newAbility.set_script(load(a).abilityScript)
		newAbility.player = get_parent()
		add_child(newAbility)
		
		match newAbility.name:
			"Grenade":
				playerData.emit_signal("updateGrenade", 15, true)
