extends Node2D


var items = []
var shells = []
var maxItems = 10


func _ready():
	GameManager.spawnManager = self


func spawn_object(object:Node):
	add_child(object)


func spawn_item(item:Node2D):
	add_child(item)
	items.append(item)
# warning-ignore:return_value_discarded
	item.connect("tree_exiting", self, "_on_item_exiting_tree", [item])
	
	while items.size() > maxItems:
		items.pop_front().queue_free()


func spawn_shell(shell:Node2D):
	add_child(shell)
	shells.append(shell.get_path())
	
	while shells.size() > 100:
		get_node(shells.pop_front()).queue_free()


func _on_item_exiting_tree(item):
	items.erase(item)

