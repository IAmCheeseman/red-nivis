extends Resource
class_name WorldData

var rooms := []
var acquiredPassives := []
var position := Vector2.ZERO
var savePosition := Vector2.ZERO
var moveDir := Vector2.ZERO
var playerPos := Vector2(160, 32)
var savePlayerPos := Vector2.ZERO
var worldSeed: int
var lastUsedTemplate: String

const BIOMES = [
	"res://World/Biomes/Lab.tres",
	"res://World/Biomes/Freezers.tres",
	"res://World/Biomes/ChemLabs.tres",
	"res://World/Biomes/DeepLabs.tres",
]

# warning-ignore:unused_signal
signal update_percent(amt)

func generate_world(seed_:int=randi()) -> void:
	worldSeed = seed_
	var worldGenerateor = WorldGenerator.new()
	var data = worldGenerateor.generate_world(seed_, lastUsedTemplate)
	rooms = data.rooms
	lastUsedTemplate = data.template
	set_starting_position()


func get_biome_by_index(idx):
	if idx == null: return null
	if idx > BIOMES.size(): return null
	return load(BIOMES[idx])


func get_current_room() -> Dictionary:
	return rooms[position.x][position.y]


func store_room_data(node:Node, value):
	if rooms.size() > 0:
		var key = str(node.get_index())
		rooms[position.x][position.y].nodeData[key] = value


func get_room_data(node:Node, defaultValue=null):
	var key = str(node.get_index())
	var roomData = rooms[position.x][position.y].nodeData
	if !roomData.has(key):
		store_room_data(node, defaultValue)
		return defaultValue
	else:
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
		var b = rooms[room.x+pos.x][room.y+pos.y].biome
		if b != null\
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


