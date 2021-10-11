extends Node

var playerData = preload("res://Entities/Player/Player.tres")

func _ready() -> void:
	for a in playerData.upgrades:
		var newAbility = Node.new()
		newAbility.set_script(a)
		newAbility.player = get_parent()
		add_child(newAbility)
