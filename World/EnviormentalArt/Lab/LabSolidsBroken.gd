extends TileMap

var playerData := preload("res://Entities/Player/Player.tres")
onready var player := playerData.playerObject

var targetA := 1.0

func _process(delta: float) -> void:
	if world_to_map(player.global_position) in get_used_cells():
		targetA = .5
	else:
		targetA = 1.0
	modulate.a = lerp(modulate.a, targetA, 5 * delta)
