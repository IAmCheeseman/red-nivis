extends Node2D


func _ready():
	randomize()
	var weaponConstructor = WeaponConstructor.new()
	var weapon = weaponConstructor.generate_weapon()

	add_child(weapon.scene)

