extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "init_gun")
	
	init_gun()


func init_gun() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	PLAYER.playerObject.itemHolder.get_child(0).get_node("GunLogic")\
		.connect("gun_shot", self, "_on_gun_shot")


func _on_gun_shot(_bullet: Node2D) -> void:
	if rand_range(0, 1) < 0.33:
		var newTrafficCone := preload("res://Items/Passives/TrafficCone/TrafficConeRigidBody.tscn").instance()
		newTrafficCone.global_position = PLAYER.playerObject.global_position - Vector2(0, 8)
		newTrafficCone.apply_central_impulse(
			PLAYER.playerObject.get_local_mouse_position().normalized() * 300
		)
		GameManager.spawnManager.spawn_object(newTrafficCone)
