extends Node2D

onready var shadow = $Shadow
onready var sprite = $Sprite

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


func _process(delta):
	shadow.region_rect = sprite.region_rect
	shadow.position.y = sprite.region_rect.size.y/2
	print(sprite.region_rect.size)
	set_process(false)
