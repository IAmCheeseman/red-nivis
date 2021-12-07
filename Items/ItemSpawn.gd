extends Position2D

export(float, 0, 1) var failChance:float = 1.0
export(Array, Resource) var itemPool
export var addForce:bool = false
export var appearOnready:bool = true
export var freeWhenDone = true
export var canGenerateWeapons = true
export var weaponChance = .6


func _process(_delta):
	if appearOnready: add_item()


func add_item():
	pass
#	if rand_range(0, 1) > failChance:
#		var weaponGenerator = WeaponConstructor.new()
#		var weapon = weaponGenerator.generate_weapon()
#
#		# Creating the dropped item
#		randomize()
#		var itemManager = ItemManagement.new()
#		var item = itemManager.create_item(weapon, addForce)
#		item.item = weapon
#		GameManager.spawnManager.spawn_item(item)
#		item.global_position = global_position
#		queue_free()
