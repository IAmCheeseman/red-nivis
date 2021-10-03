extends Resource
class_name WorldData

var rooms := []
var position := Vector2.ZERO
var moveDir := Vector2.ZERO
var biomes := [
	preload("res://World/Biomes/Lab.tres"),
	preload("res://World/Biomes/DeepLabs.tres")
]


func _init() -> void:
	randomize()
	generate_world()
	set_starting_position()


func generate_world(seed_:int=randi()) -> void:
	var worldGenerateor = WorldGenerator.new()
	rooms = worldGenerateor.generate_world(seed_)


func get_connected_rooms(room:Vector2) -> Array:
	var pos := Vector2(-1, -1)
	var connections := []
	for i in 9:
		if rooms[room.x+pos.x][room.y+pos.y].biome and !pos in [Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), Vector2(1, 1), Vector2.ZERO]:
			connections.append(pos)
		pos.x = wrapi(int(pos.x+1), -1, 2)
		if pos.x == -1: pos.y += 1
	return connections


func set_starting_position() -> void:
	var startingArea = preload("res://World/Biomes/Caves.tres")
	var viableRooms = []
	for x in rooms.size():
		for y in rooms[0].size():
			if rooms[x][y].biome == startingArea:
				viableRooms.append(Vector2(x, y))
	viableRooms.shuffle()
	position = viableRooms.front()


