extends Reference
class_name RoomPlacer

func generate_rooms(
rooms: Array,
room: Resource,
amountPerBiome:int,
minDistance:float,
whitelistedBiomes: Array) -> void:
	for b in whitelistedBiomes:
		var usedRooms := []
		var i = 0
		var timesTried := 0
		while i < amountPerBiome and timesTried < 100:
			timesTried += 1
			var selectedPos = Vector2(
				rand_range(0, rooms.size()-1),
				rand_range(0, rooms[0].size()-1)
			)
			var selectedRoom = rooms\
				[selectedPos.x]\
				[selectedPos.y]
			
			var roomOkay = true
			for j in usedRooms:
				if j.distance_to(selectedPos) <= minDistance:
					roomOkay = false
			
			if selectedRoom.biome != b or !roomOkay or selectedRoom.constantRoom: continue
			selectedRoom.constantRoom = room
			selectedRoom.roomIcon = room.roomIcon
			selectedRoom.typeAlwaysVisible = room.typeAlwaysVisible
			usedRooms.append(selectedPos)
			i += 1
