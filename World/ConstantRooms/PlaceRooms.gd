extends Reference
class_name Thing

var amountPerBiome := 3
var minDistance := 2.8
var room = preload("res://World/ConstantRooms/Rooms/FastTravelRoom.tres")
var whitelistedBiomes := [preload("res://World/Biomes/Lab.tres")]
var whitelistAllBiomes := false

func generate_rooms(rooms: Array) -> void:
	for b in whitelistedBiomes:
		var usedRooms := []
		var i = 0
		while i < amountPerBiome:
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
			
			if selectedRoom.biome != b or !roomOkay: continue
			selectedRoom.constantRoom = room
			selectedRoom.roomIcon = room.roomIcon
			usedRooms.append(selectedPos)
			i += 1
