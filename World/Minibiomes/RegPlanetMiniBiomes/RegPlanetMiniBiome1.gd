extends Node

var minibiome:Minibiome
var map:Image


func generate_biome():
	var startingPoint = Vector2(
		round(rand_range(0, map.get_width())),
		round(rand_range(0, map.get_height()))
	)

	# getting tile limits
	var size = Vector2(
		rand_range(minibiome.minSize.y, minibiome.maxSize.y),
		rand_range(minibiome.minSize.x, minibiome.maxSize.x)
	)

	var noise = OpenSimplexNoise.new()
	noise.seed = minibiome.minSize.x
	noise.period = 15.5
	noise.persistence = .5
	noise.octaves = 1

	for x in size.x:
		for y in size.y:
			if noise.get_noise_2d(startingPoint.x+x, startingPoint.y+y) < .5:
				map.set_pixel(
					clamp(startingPoint.x+x, 0, map.get_width()-1),
					clamp(startingPoint.y+y, 0, map.get_height()-1),
					minibiome.bgColor)
			else:
				map.set_pixel(
					clamp(startingPoint.x+x, 0, map.get_width()-1),
					clamp(startingPoint.y+y, 0, map.get_height()-1),
					minibiome.tilesColor)








