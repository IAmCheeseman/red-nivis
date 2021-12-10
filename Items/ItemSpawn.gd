extends Position2D

export(float, 0, 1) var failChance:float = 1.0
export(Array, String) var itemPool
export var addForce:bool = false
export var appearOnready:bool = true


func _process(_delta):
	if appearOnready: add_item()


func add_item():
	if itemPool.size() <= 0: queue_free()
	if rand_range(0, 1) > failChance:
		itemPool.shuffle()
		var weapon = itemPool.pop_front()
		
		# Creating the dropped item
		var itemManager = ItemManagement.new()
		var item = itemManager.create_item(weapon, addForce)
		item.z_index = 1
		GameManager.spawnManager.spawn_object(item)
		item.global_position = global_position
		queue_free()
