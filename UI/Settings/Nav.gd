extends Control

export var buttonPth: NodePath
export var toPth: NodePath

onready var button = get_node(buttonPth)
onready var to = get_node(toPth)

func _ready() -> void:
	button.connect("pressed", self, "change_menu")


func change_menu() -> void:
	hide()
	to.show()
