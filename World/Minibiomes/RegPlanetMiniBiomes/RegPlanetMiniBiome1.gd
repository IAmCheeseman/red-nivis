extends Node

var minibiome:Minibiome
var map:Image


func generate_biome():
	var startingPoint = get_starting_point()
	var genLayer = minibiome.generationLayer
	while !GameManager.get_world_layer(startingPoint.y)[genLayer]:
		startingPoint = get_starting_point()

	# getting tile limits
	var size = Vector2(
		rand_range(minibiome.minSize.y, minibiome.maxSize.y),
		rand_range(minibiome.minSize.x, minibiome.maxSize.x)
	)

	var imgManip = ImageManipulation.new()

	map.unlock()
	imgManip.draw_circle(map, startingPoint, size, minibiome.bgColor)
	map.lock()

	var noise = OpenSimplexNoise.new()
	noise.seed = minibiome.minSize.x
	noise.period = 15.5/2
	noise.persistence = .5
	noise.octaves = 1

	for x in size.x:
		for y in size.y:
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
			if map.get_pixel(
				clamp(startingPoint.x+x, 0, map.get_width()-1),
				clamp(startingPoint.y+y, 0, map.get_height()-1)
				).is_equal_approx(minibiome.bgColor):
				if noise.get_noise_2d(startingPoint.x+x, startingPoint.y+y) > .25:
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
					map.set_pixel(
						clamp(startingPoint.x+x, 0, map.get_width()-1),
						clamp(startingPoint.y+y, 0, map.get_height()-1),
						minibiome.tilesColor)


func get_starting_point() -> Vector2:
	return Vector2(
		round(rand_range(0, map.get_width()-1)),
		round(rand_range(0, map.get_height()-1))
	)







