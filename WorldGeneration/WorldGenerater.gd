extends Node

# Gets surrounding tiles
func get_neighbors(tilePos : Vector2, tileset : TileMap, getCorners = false) -> Array:
	var xx = -1
	var yy = -1

	var CORNERTILES = [
		Vector2(1, 1),
		Vector2(1, -1),
		Vector2(-1, 1),
		Vector2(-1, -1)
	]

	var neighboringTiles = []

	for tile in range(9):
		if tile == 5:
			continue

		if getCorners:
			neighboringTiles.append(tileset.get_cell(tilePos.x+xx, tilePos.y+yy))
		elif !Vector2(xx, yy) in CORNERTILES:
			neighboringTiles.append(tileset.get_cell(tilePos.x+xx, tilePos.y+yy))

		xx += 1
		xx = wrapi(xx, -1, 2)
		if xx == -1:
			yy += 1
	return neighboringTiles
