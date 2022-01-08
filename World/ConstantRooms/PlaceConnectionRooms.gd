extends Reference
class_name ConnectionRoomPlacer

const CONNECTION_ROOMS = {
	"labs-caves"     : preload("res://World/ConstantRooms/Rooms/DeepLabsBlock.tres"),
	"labs-deeplabs"  : preload("res://World/ConstantRooms/Rooms/DeepLabsBlock.tres"),
	"caves-deeplabs" : preload("res://World/ConstantRooms/Rooms/DeepLabsBlock.tres"),
}

static func generate_rooms(rooms:Array, wg):

	for x in rooms.size():
		for y in rooms[x].size():
			var room = rooms[x][y]
			if !room.isBiomeConnection: continue
			var neighbors = wg.get_neighbors(
				Vector2(x, y),
				false,
				false
			)
			var biomes = []
			for i in neighbors:
				var iroom = rooms[i.x][i.y]
				if iroom.biome:
					room.biome = iroom.biome
					room.typeAlwaysVisible = true
					biomes.append(
						wg.get_biome_by_index(iroom.biome).name\
						.replace(" ", "").to_lower()
					)
				print(biomes.size())
				if biomes.size() == 2: break
			if biomes.size() != 2: continue
			
			var possibleKey1 = "%s-%s" % [biomes[0], biomes[1]]
			var possibleKey2 = "%s-%s" % [biomes[1], biomes[0]]
			if possibleKey1 == possibleKey2: continue
			var r
			if CONNECTION_ROOMS.has(possibleKey1):
				r = CONNECTION_ROOMS[possibleKey1]
			else:
				r = CONNECTION_ROOMS[possibleKey2]
			
			room.biome = r.constBiome.biomeIndex
			room.constantRoom = r
			room.roomIcon = r.roomIcon
