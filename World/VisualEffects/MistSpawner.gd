extends Node2D
tool

export var worldPath:NodePath
export var playerPath:NodePath
export var mistClumpSize = 4
export var mistClumRange = 4
export var clumpSpread = 64
export var color : Color
export var strength = .5

onready var world = get_node(worldPath)
onready var player:Node2D = get_node(playerPath)

var mist = load("res://World/VisualEffects/Mist.tscn")


func spawn_mist():
	var clumpSize = rand_range(clamp(mistClumpSize-mistClumRange, 1, INF), mistClumpSize+mistClumRange)
	var camSize = get_viewport_rect().end
	var mistPos = global_position+Vector2(
		rand_range(-camSize.x*.5, camSize.x*.5), rand_range(-camSize.y*.5, camSize.y*.5))

	for nm in clumpSize:
		var newMist = mist.instance()
		newMist.rect_global_position = mistPos+Vector2(rand_range(-clumpSpread, clumpSpread), rand_range(-clumpSpread, clumpSpread))
		newMist.player = player
		var node = Node2D.new()
		node.name = "MistHolder"
		node.z_index = -2
		GameManager.spawnManager.spawn_object(node)
		node.add_child(newMist)
		newMist.set_param(color, strength)


