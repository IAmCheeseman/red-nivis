extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")

var visuals: Node2D
var backVisuals: Node2D
var gun: Node2D


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "init_gun")
	
	init_gun()


func _process(delta: float) -> void:
	if is_instance_valid(visuals) and is_instance_valid(backVisuals):
		backVisuals.scale.y = visuals.scale.y
		backVisuals.rotation = -visuals.rotation


func init_gun() -> void:
	gun = PLAYER.playerObject.itemHolder.get_child(0)
	gun.isTwoHanded = true
	
	var gunLogic = gun.get_node("GunLogic")
	var canConnect := true
	for i in gunLogic.get_signal_connection_list("gun_shot"):
		if i.target == self:
			canConnect = false
			break
	if canConnect: gunLogic.connect("gun_shot", self, "_on_gun_shot")
	visuals = gun.visuals
	backVisuals = visuals.duplicate()
	backVisuals.scale.x = -1
	backVisuals.position.x *= -1
	gun.pivot.add_child(backVisuals)


func _on_gun_shot(bullet: Node2D) -> void:
	var newBullet = bullet.duplicate(DUPLICATE_SCRIPTS)
	newBullet.direction = -bullet.direction
	newBullet.speed = bullet.speed
	newBullet.damage = bullet.damage
	newBullet.peircing = bullet.peircing
	newBullet.lifetime = bullet.lifetime
	GameManager.spawnManager.spawn_object(newBullet)
	yield(TempTimer.idle_frame(self), "timeout")
	if !is_instance_valid(newBullet): return
	newBullet.global_position -= newBullet.direction * -gun.bulletSpawnDist * 2
