extends Reference
class_name DodgeRoomPlacer

const ROOMS = [
	"res://World/ConstantRooms/DodgeRooms/DodgeRoom1.tres",
]

static func generate_rooms(rooms:Array, worldGenerator):
	for x in rooms.size():
		for y in rooms[x].size():
			var room = rooms[x][y]
			if !room.isDodgeRoom: continue
			var dodgeRooms = ROOMS.duplicate()
			dodgeRooms.shuffle()
			
			room.constantRoom = dodgeRooms.pop_front()
