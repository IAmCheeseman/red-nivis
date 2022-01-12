extends "res://Items/Weapons/WeaponScripts/ProjectileBasedGun.gd"

export var fire: NodePath


func _ready() -> void:
	var _discard = connect("gun_shot", self, "_on_shoot")


func _on_shoot(bullet: Node2D) -> void:
	get_node(fire).emitting = true
	bullet.hide()
