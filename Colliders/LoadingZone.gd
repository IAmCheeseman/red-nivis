extends Area2D

export var loadPath : String
export(Array, String) var loadPaths
export var outputVec : Vector2
export var inWorld = true
export var reqiurePrompt = true
export var loadFromMemory = false
export var memorySlot = 0

var worldRoot : Node2D
var closeEnough = false


onready var prompt = $Prompt


func _ready():
	if inWorld: worldRoot = get_tree().root.get_child(4)


func _on_LoadingZone_area_entered(area):
	if reqiurePrompt:
		closeEnough = true
		prompt.show()
		return

	if area.is_in_group("player"):
		load_area()


func _on_LoadingZone_area_exited(area):
	if area.is_in_group("player"):
		prompt.hide()
		closeEnough = false


func _input(event):
	if event.is_action_pressed("interact") and closeEnough:
		load_area()


func load_area():
	if loadFromMemory:
		get_tree().root.call_deferred("add_child", Memory.inMemory[memorySlot])
		get_parent().queue_free()
		return

	if inWorld and worldRoot:
		if loadPaths.size() > 0:
			loadPaths.shuffle()
			loadPath = loadPaths[0]
		GameManager.load_scene(loadPath)
		Memory.inMemory.insert(0, worldRoot)
		worldRoot.get_parent().call_deferred("remove_child", worldRoot)

