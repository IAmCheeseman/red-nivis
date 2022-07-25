extends Resource
class_name DialogInteraction


export(Array, Array, String, MULTILINE) var dialog = []


func get_interaction(interaction: String):
	for i in dialog:
		if i[0] == interaction:
			return i
	return null
