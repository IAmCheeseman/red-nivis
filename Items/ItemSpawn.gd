extends Position2D

export(float, 0, 1) var failChance:float = 1.0
export(Array, Resource) var itemPool


func _ready():
	if rand_range(0, 1) <= failChance:
		var selectedTable:LootTable = itemPool[rand_range(0, itemPool.size())]
		var selectedIndex = rand_range(0, selectedTable.loot.size())
		var loops = 0
		while rand_range(0, 1) > selectedTable.rarites[selectedIndex]\
		and loops < 0:
			selectedIndex = rand_range(0, selectedTable.loot.size())
			loops += 1
		var selectedItem = selectedTable.loot[selectedIndex]

		var itemManager = ItemManagement.new()
		var item = itemManager.create_item(selectedItem)
		item.global_position = position
		yield(get_tree(), "idle_frame")
		get_parent().add_child(item)
	queue_free()
