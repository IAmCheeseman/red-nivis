extends Node2D

export var nodePool : NodePath

var node : Node2D


onready var sprite = $Sprite


func _ready():
	_on_Ship_changePlanetFinder(0)


func _process(_delta):
	look_at(node.global_position)
	var dist = global_position.distance_to(node.global_position)
	
	var scaleWeight = 1700
	var minScale = .5
	
	# Starts getting larger at 850 distance
	var distReduced = dist/scaleWeight
	distReduced = 1-clamp(distReduced, 0, minScale)
	sprite.scale = Vector2(distReduced, distReduced)
	
	sprite.position.x = dist/50

func _on_Ship_changePlanetFinder(planet):
	if planet == -1:
		visible = !visible
		return
	node = get_node(nodePool).get_child(planet)
