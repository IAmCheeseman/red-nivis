extends Resource
class_name WorldData

var rooms := []
var position := Vector2.ZERO


func _init() -> void:
	randomize()
	generate_world()
	set_starting_position()


func generate_world(seed_:int=randi()):
	var worldGenerateor = WorldGenerator.new()
	rooms = worldGenerateor.generate_world(seed_)


func set_starting_position() -> void:
	var startingArea = preload("res://World/Biomes/Lab.tres")
	var viableRooms = []
	for x in rooms.size():
		for y in rooms[0].size():
			if rooms[x][y].biome == startingArea:
				viableRooms.append(Vector2(x, y))
	viableRooms.shuffle()
	position = viableRooms.front()


