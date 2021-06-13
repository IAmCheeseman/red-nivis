extends Node
class_name CellularAutomata


func iterate(image:Image, iterations:int=5, starveMin:int=3, overPop:int=5, aliveColor:Color=Color("#000000")) -> Image:
	var newImage:Image = image.duplicate()
	var imageBorders = Rect2(Vector2.ZERO, Vector2(newImage.get_width(), newImage.get_height()) )
	newImage.lock()

	for iteration in iterations:
		var changes = []

		# Iterating
		for x in image.get_width():
			for y in image.get_height():
				if newImage.get_pixel(x, y).is_equal_approx(aliveColor):
					continue

				var neighbors = get_neighbors(x, y)
				var aliveCells = 0
				# Checking if the cell needs to become alive
				for neighbor in neighbors:
					if !imageBorders.has_point(neighbor):
						aliveCells += 1
					elif newImage.get_pixelv(neighbor).is_equal_approx(aliveColor):
						aliveCells += 1
				# If it meets the minimum requirements, it becomes alive
				if aliveCells >= starveMin and aliveCells < overPop:
					changes.append(Vector2(x, y))

		# Making the changes
		for change in changes:
			newImage.set_pixelv(change, aliveColor)
	return newImage


func get_neighbors(x:int, y:int):
	return [
		Vector2(x, y-1),   #     north
		Vector2(x, y+1),   #     south
		Vector2(x+1, 1),   #      east
		Vector2(x-1, y),   #      west
#		Vector2(x+1, y-1), # northeast
#		Vector2(x-1, y-1), # northwest
#		Vector2(x+1, y+1), # southeast
#		Vector2(x-1, y+1)  # southwest
	]



