extends Node

var playerData = preload("res://Entities/Player/Player.tres")

func _ready() -> void:
	add_abilities()

func add_abilities() -> void:
	for i in get_children(): i.queue_free()
	for a in playerData.upgrades:
		var newAbility = Node.new()
		newAbility.set_script(a)
		newAbility.player = get_parent()
		add_child(newAbility)
