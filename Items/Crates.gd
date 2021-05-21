extends Node2D

var crates = [
	"SingleCrates",
	"MultipleCrates"
]

func _ready():
	randomize()
	if rand_range(0, 2) <= 1:
		queue_free()
		return
	crates.shuffle()
	var crateNum = get_node(crates[0])
	var keys = Array(crateNum.get_animation_list())
	crateNum.play(keys[rand_range(0, keys.size())])
