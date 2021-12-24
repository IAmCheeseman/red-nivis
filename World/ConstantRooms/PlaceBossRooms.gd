extends Reference
class_name BossRoomPlacer


static func generate_rooms(rooms:Array, brooms: Array, worldGenerator):
	for r in brooms:
		for x in rooms.size():
			for y in rooms[x].size():
				var room = rooms[x][y]
				if !room.bossRoom: continue
				var neighbors = worldGenerator.get_neighbors(
					Vector2(x, y),
					false,
					false
				)
				var correctBiome = false
				for i in neighbors:
					var iroom = rooms[i.x][i.y]
					if iroom.biome in r.biomes:
						room.biome = iroom.biome
						room.typeAlwaysVisible = true
						correctBiome = true
						break
				if !correctBiome: continue
				room.constantRoom = r
				room.roomIcon = r.roomIcon
				
