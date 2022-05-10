extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")
var gun: Node2D

func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "connect_signal")
	
	connect_signal()


func connect_signal() -> void:
	gun = PLAYER.playerObject.itemHolder.get_child(0)
	var _discard = gun.gunLogic.connect("melee", self, "_on_melee")


func _on_melee() -> void:
	var newBullet = preload(\
		"res://Items/Weapons/Bullet/AltBullets/ShieldBullet/ShieldBullet.tscn"\
	).instance()
	
	var dir = gun.get_local_mouse_position().normalized()
	
	newBullet.direction = dir
	newBullet.speed = 450
	newBullet.lifetime = 0.5
	newBullet.global_position = gun.global_position + dir * 18
	
	GameManager.spawnManager.spawn_object(newBullet)
	
	yield(TempTimer.idle_frame(self), "timeout")
	
	newBullet.set_texture(
		preload("res://Items/Passives/ToiletPaper/ToiletPaperProj.png")
	)
