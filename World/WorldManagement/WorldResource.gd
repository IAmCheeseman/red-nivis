extends Resource
class_name WorldData

var rooms := []
var position := Vector2.ZERO
var savePosition := Vector2.ZERO
var savePlayerPos := Vector2.ZERO
var moveDir := Vector2.ZERO
var playerPos := Vector2(160, 32)


func generate_world(seed_:int=randi()) -> void:
	var worldGenerateor = WorldGenerator.new()
	rooms = worldGenerateor.generate_world(seed_)
	set_starting_position()


func get_current_room() -> Dictionary:
	return rooms[position.x][position.y]


func store_room_data(node:Node, value):
	var key = str(node.get_index())
	rooms[position.x][position.y].nodeData[key] = value


func get_room_data(node:Node, defaultValue=null):
	var key = str(node.get_index())
	var roomData = rooms[position.x][position.y].nodeData
	if !roomData.has(key):
		store_room_data(node, defaultValue)
		return defaultValue
	else:
		print(roomData[key])
		return roomData[key]


func get_connected_rooms(room:Vector2) -> Array:
	var pos := Vector2(-1, -1)
	var connections := []
	for i in 9:
		var dirs = [
			Vector2(-1, -1),
			Vector2(1, -1),
			Vector2(-1, 1),
			Vector2(1, 1),
			Vector2.ZERO
		]
		if rooms[room.x+pos.x][room.y+pos.y].biome\
		and !pos in dirs:
			connections.append(pos)
		pos.x = wrapi(int(pos.x+1), -1, 2)
		if pos.x == -1: pos.y += 1
	return connections


func set_starting_position() -> void:
	for x in rooms.size():
		for y in rooms[0].size():
			if rooms[x][y].isStartingRoom:
				position = Vector2(x, y)
				return


