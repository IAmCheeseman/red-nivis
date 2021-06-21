extends Node2D

var worldData = preload("res://WorldGeneration/WorldManagement/WorldData.tres")

signal worldGenUpdated(percentage)
signal worldGenDone()


func move_in_direction(direction):
	worldData.lastUpdatedDir = direction
	worldData.position.x = wrapi(worldData.position.x+direction.x, 0, worldData.rooms[0].size())
	worldData.position.y = wrapi(worldData.position.y+direction.y, 0, worldData.rooms.size())
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func generate_world(_thread:Thread):
	var rooms = []
	var dimensions = Vector2(30, 20)
	var roomsDone = 0
	var totalRooms = dimensions.x*dimensions.y

	for x in dimensions.x:
		rooms.append([])
		for y in dimensions.y:
			var newRoom = {
				"layout" : null,
				"isLanding" : false,
			}

			rooms[x].append(newRoom)

			roomsDone += 1
			emit_signal("worldGenUpdated", GameManager.percentage_of(roomsDone, totalRooms))

	worldData.rooms = rooms

	emit_signal("worldGenDone")
