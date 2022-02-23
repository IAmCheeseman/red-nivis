extends Node2D
class_name BossDropper

export var spritePath: NodePath
onready var sprite = get_node(spritePath)
export var drops = [
	preload("res://Items/HeartContiner/HeartContainer.tscn"),
	preload("res://Items/Upgrades/DroppedUpgrade.tscn")
]
export var doDrop := true

var rc: RayCast2D


func _ready() -> void:
	var _discard = connect("tree_exiting", self, "_on_tree_exiting")


func _on_tree_exiting() -> void:
	if !doDrop: return
	
	rc = RayCast2D.new()
	rc.cast_to = Vector2.DOWN * 1000
	rc.set_collision_mask_bit(5, true)
	add_child(rc)
	for i in drops.size():
		var d = drops[i]
		var newDrop:Node2D = d.instance()
		var pos = global_position-Vector2(0, sprite.texture.get_height()*.25)
		pos.x += (drops.size()*.5-i)*32
		rc.global_position = pos
		rc.force_raycast_update()
		if rc.is_colliding():
			newDrop.global_position = rc.get_collision_point() + (Vector2.UP * 32)
			GameManager.spawnManager.spawn_object(newDrop)
			continue
		newDrop.queue_free()
