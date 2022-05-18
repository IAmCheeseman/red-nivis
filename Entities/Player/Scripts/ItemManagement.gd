extends Node

export var itemHolderPath:NodePath

onready var itemHolder = get_node(itemHolderPath)

var inventory = preload("res://UI/Inventory/Inventory.tres")
var playerData = preload("res://Entities/Player/Player.tres")

signal itemsChanged


func _ready():
	inventory.connect("selectedSlotChanged", self, "add_item")
	inventory.connect("itemsChanged", self, "add_item")
	add_item()


func add_item():
	if itemHolder == null: return
	
	Utils.free_children(itemHolder)
	var item = inventory.items[inventory.selectedSlot]
	if item == null: return

	if item is Dictionary:
		var newItem = load(item.itemData.scene).instance()
		newItem.invenIdx = inventory.selectedSlot
		newItem.player = playerData

		itemHolder.add_child(newItem)
		
		playerData.maxAmmo = newItem.magazineSize
		playerData.ammo = playerData.maxAmmo
	emit_signal("itemsChanged")
