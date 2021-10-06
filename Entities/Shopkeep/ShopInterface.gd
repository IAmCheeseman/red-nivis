extends CenterContainer

onready var scrollBox = $Vbox/Shop/ScrollContainer
onready var items = $Vbox/Shop/ScrollContainer/Items

var slot = preload("res://Entities/Shopkeep/ShopSlot.tscn")


func _ready() -> void:
	randomize()
	for i in items.get_children(): i.queue_free()
	for i in rand_range(3, 5):
		var weapon = WeaponConstructor.new().generate_weapon()
		var newSlot = slot.instance()
		items.add_child(newSlot)
		newSlot.set_item(weapon)


func update_slots():
	for i in items.get_children():
		i.set_item(i.item)


func _on_up_scroll_pressed() -> void:
	scrollBox.scroll_vertical -= 5

func _on_down_scroll_pressed() -> void:
	scrollBox.scroll_vertical += 5
