extends Control

onready var itemName = $ItemName
onready var itemAmount = $ItemAmount


func setup(name_:String, amount:int):
	itemName.text = " %s" % name_
	itemAmount.text = "x%s " % amount
