extends Node2D


var items = []
var maxItems = 10


func _ready():
	GameManager.spawnManager = self


func spawn_object(object:Node):
	add_child(object)


func spawn_item(item:Node2D):
	add_child(item)
	items.append(item)
	item.connect("tree_exiting", self, "_on_item_exiting_tree", [item])
	
	while items.size() > maxItems:
		items.pop_front().queue_free()


func _on_item_exiting_tree(item):
	items.erase(item)

