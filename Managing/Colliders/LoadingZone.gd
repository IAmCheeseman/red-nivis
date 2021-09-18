extends Area2D

export var loadPath : String
export(Array, String) var loadPaths
export var outputVec : Vector2
export var inWorld = true
export var reqiurePrompt = true
export var emitSignalInstead = false
export var loadFromMemory = false
export var memorySlot = 0

var worldRoot : Node2D
var closeEnough = false


onready var prompt = $Prompt

signal loadArea


func _ready():
	if inWorld: worldRoot = get_tree().root.get_child(5)


func _on_LoadingZone_area_entered(area):
	if !area.is_in_group("player"):
		return
	if reqiurePrompt:
		closeEnough = true
		prompt.show()
		return
	load_area()


func _on_LoadingZone_area_exited(area):
	if area.is_in_group("player"):
		prompt.hide()
		closeEnough = false


func _input(event):
	if event.is_action_pressed("interact") and closeEnough:
		load_area()


func load_area():
# warning-ignore:return_value_discarded
	if emitSignalInstead:
		emit_signal("loadArea")
		return
	get_tree().change_scene(loadPath)

