extends Node2D

onready var shop = $CanvasLayer
onready var playerInven = find_node("PlayerWeapons")
onready var shopInven = find_node("ShopWeapons")
onready var warning = find_node("Warning")

var inventory = preload("res://UI/Inventory/Inventory.tres")


func _ready() -> void:
	open_shop(false)


func update_items(items:=inventory.items, par:=playerInven) -> void:
	Utils.free_children(par)
	for i in items:
		if !i is Dictionary: return
		var newButton = preload("res://Entities/NPC/Birb/WeaponButton.tscn").instance()
		par.add_child(newButton)
		newButton.toggle_mode = true
		newButton.setup(load(i.slotTexture), i.name)
		newButton.connect("pressed", self, "_on_player_weapon_chosen", [newButton])


func open_shop(open:=true) -> void:
	update_items()
	_on_player_weapon_chosen(null)
	for i in shop.get_children():
		i.visible = open
	warning.show()
	GameManager.inGUI = open


func _on_player_weapon_chosen(button: CustomButton) -> void:
	for i in playerInven.get_children():
		if i != button:
			i.pressed = false
	if button:
		warning.hide()
		update_items(find_same_tier_items(inventory.items[button.get_index()].tier), shopInven)


func find_same_tier_items(tier: int) -> Array:
	var items := []
	
	for key in ItemMap.ITEMS.keys():
		var k_tier = ItemMap.ITEMS[key].tier
		if k_tier == tier:
			items.append(ItemMap.ITEMS[key])
	
	return items


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		open_shop(false)
		Utils.free_children(shopInven)
