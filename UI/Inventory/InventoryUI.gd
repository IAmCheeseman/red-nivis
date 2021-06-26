extends Control

onready var slots = $CenterContainer/Slots

var slot = preload("res://UI/Inventory/Slot.tscn")
var inventory = preload("res://UI/Inventory/Inventory.tres")


func _ready():
	inventory.connect("itemsChanged", self, "refresh_items")


func format_name(iName:String) -> String:
	var formattedName = iName
	formattedName.format(" ", "_")
	var startHidden = formattedName.find("|")
	var endHidden = formattedName.find_last("|")
	var i = startHidden
	while i < endHidden:
		formattedName.replace(formattedName[i], "")
		i += 1

	return formattedName


func refresh_items():
	for c in slots.get_children():
		c.queue_free()
	
	for i in inventory.items:
		pass