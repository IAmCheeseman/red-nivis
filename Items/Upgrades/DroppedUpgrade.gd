extends Node2D

onready var sprite = $Sprite
onready var tutorial = $CanvasLayer
onready var tween = $Tween

export var upgrade:Resource = preload("res://Items/Upgrades/Teleport/Teleport.tres")

var player = preload("res://Entities/Player/Player.tres")


func _ready():
	sprite.texture = upgrade.icon
	for i in tutorial.get_children(): i.hide()
	find_node("Tutorial").text = upgrade.howTo
	find_node("Title").bbcode_text = "[center]You have acquired the [color=yellow]%s[/color]:" % upgrade.name
	find_node("Display").texture = upgrade.icon


func _on_interaction():
	if player.upgrades.has(upgrade.resource_path): return
	player.upgrades.append(upgrade.resource_path)
	player.playerObject.get_node("Abilities").add_abilities()
	
	for i in tutorial.get_children(): i.show()
	tween.interpolate_property(Engine, "time_scale", 1, 0, .2)
	tween.start()
	GameManager.inGUI = true


func finish() -> void:
	tween.stop_all()
	Engine.time_scale = 1
	GameManager.inGUI = false
	queue_free()
