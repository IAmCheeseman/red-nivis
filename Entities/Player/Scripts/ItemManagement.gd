extends Node

export var itemHolderPath:NodePath

onready var itemHolder = get_node(itemHolderPath)

var inventory = preload("res://UI/Inventory/Inventory.tres")
var playerData = preload("res://Entities/Player/Player.tres")


func _ready():
	inventory.connect("selectedSlotChanged", self, "add_item")
	inventory.connect("itemsChanged", self, "add_item")
	add_item()


func add_item():
	if itemHolder == null:
		return
	
	for i in itemHolder.get_children():
		i.queue_free()
	var item = inventory.items[inventory.selectedSlot]
	if item == null: return

	if item is Dictionary:
		var newItem = load("res://Items/Weapons/Gun.tscn").instance()
		newItem.stats = item
		newItem.player = playerData
		
		var timer = get_tree().create_timer(.01)
		timer.connect("timeout", self, "add_item_to_player", [item, newItem])


func add_item_to_player(item, newItem) -> void:
	playerData.maxAmmo = item.magazineSize
	playerData.ammo = playerData.maxAmmo
	
	itemHolder.add_child(newItem)
