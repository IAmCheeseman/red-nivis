tool
extends Node2D

export var tilePath:NodePath
export var updateTiles = false setget update_tiles


func update_tiles(value):
	var tiles:TileMap = get_node(tilePath)
	tiles.update_bitmask_region(tiles.get_used_rect().position, tiles.get_used_rect().end)
	
