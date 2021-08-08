extends Position2D

export(float, 0, 1) var failChance:float = 1.0
export(Array, Resource) var itemPool
export var addForce:bool = false
export var appearOnready:bool = true
export var freeWhenDone = true


func _process(_delta):
	if appearOnready: add_item()


func add_item():
	if rand_range(0, 1) > failChance:
		var selectedTable:LootTable = itemPool[rand_range(0, itemPool.size())]
		var selectedIndex = rand_range(0, selectedTable.loot.size())
		var loops = 0
		while rand_range(0, 1) > selectedTable.rarites[selectedIndex]\
		and loops < 0:
			selectedIndex = rand_range(0, selectedTable.loot.size())
			loops += 1
		var selectedItem = selectedTable.loot[selectedIndex]

		var itemManager = ItemManagement.new()
		var item = itemManager.create_item(selectedItem, addForce)
		item.global_position = global_position
		GameManager.spawnManager.spawn_object(item)
	if freeWhenDone:
		queue_free()
