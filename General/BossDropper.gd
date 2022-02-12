extends Node2D
class_name BossDropper

export var spritePath: NodePath
onready var sprite = get_node(spritePath)
export var drops = [
	preload("res://Items/HeartContiner/HeartContainer.tscn"),
	preload("res://Items/Upgrades/DroppedUpgrade.tscn")
]


func drop_items() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	for i in drops.size():
		var d = drops[i]
		var newDrop:Node2D = d.instance()
		newDrop.position = position-Vector2(0, sprite.texture.get_height()*.25)
		newDrop.position.x += (drops.size()*.5-i)*32
		GameManager.spawnManager.spawn_object(newDrop)
