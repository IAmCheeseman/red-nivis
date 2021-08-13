extends Node

enum {
	ARG_INT,
	ARG_STR,
	ARG_BOOL,
	ARG_FLOAT
}

var inventory = preload("res://UI/Inventory/Inventory.tres")
var player = preload("res://Player/Player.tres")

const VALID_COMMANDS = {
	"timescale" :
		[ARG_FLOAT],
	"give" :
		[ARG_STR],
	"getitems" :
		[],
	"setspeed" :
		[ARG_INT],
	"sethealth" :
		[ARG_INT],
	"setmaxhealth" :
		[ARG_INT],
	"setammo" :
		[ARG_INT],
	"help" :
		[]
}


func timescale(scale:float):
	Engine.time_scale = scale
	return "Set engine property 'time_scale' to %s" % scale


func give(item:String):
	if !inventory.check_existence(item):
		return "Item '%s' does not exist." % item

	inventory.add_item(item)
	return "Added item '%s'." % item


func setspeed(amount:int):
	player.maxSpeed = amount
	return "Set max speed to %s." % amount


func sethealth(amount:int):
	player.health = amount
	return "Set health to %s." % amount


func setmaxhealth(amount:int):
	player.maxHealth = amount
	player.health = amount
	return "Set max health to %s." % amount


func setammo(amount:int):
	player.ammo = amount
	return "Set ammo to %s." % amount


func getitems():
	var itemList = "HELP\nThese are the codes for each item:\n\n"
	for i in inventory.itemMap.keys():
		itemList += i+"\n"
	return itemList


func help():
	var helpList = "HELP\nCommand names:\n\n"
	for i in VALID_COMMANDS.keys():
		helpList += i+"\n"
	return helpList






