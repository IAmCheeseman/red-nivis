extends Resource
class_name WorldGenerator

#var worldSize:Vector2 = Vector2(1000, 700)
#var hillSize :float = 5
#var horizen:int = 500
#var roughness:int = 1
#var tileSize:int = 8
#var heightSmoothing:Curve
#var overHangSmoothing:Curve
#var caveSize:Curve


func generate_world(size:Vector2, horizen:int, elevationNoise:OpenSimplexNoise) -> Image:
	randomize()
	elevationNoise.seed = randi()

	# Defining colors
	var solidColor := Color("#000000")
	var emptyColor := Color("#ffffff")

	# Creating a global size
	var templateSize:int = 16
	var globalSize = size*templateSize

	# Getting the templates
	var flatTemplates:Image = preload("res://World/Templates/FlatTemplates.png").get_data()
	var connectionTemplates:Image = preload("res://World/Templates/ConnectionTemplates.png").get_data()
	# Getting the template amounts
	var flatTemplateAmount := flatTemplates.get_width()/templateSize
	var connectionTemplateAmount := connectionTemplates.get_width()/templateSize
	# Making sure that the templates are in the correct format
	flatTemplates.convert(Image.FORMAT_RGB8)
	connectionTemplates.convert(Image.FORMAT_RGB8)

	# Creating the map
	var map:Image = Image.new()
	map.create(globalSize.x, globalSize.y, false, Image.FORMAT_RGB8)

	map.lock()
	map.fill(emptyColor)
	map.unlock()

	# Creating the horizen
	map.lock()
	var groundToSkyDist:int = globalSize.y-horizen
	print(groundToSkyDist)
	for x in globalSize.x:
		for y in horizen:
			map.set_pixel(x, y+groundToSkyDist, solidColor)

	var templateYs:PoolIntArray = []
	# Creating the general layout
	for x in size.x:
		# Getting the block height
		var globalX = x*templateSize
		var height = stepify(elevationNoise.get_noise_1d(globalX)+1, .5)*2
		height = clamp(height, 0, 3)
		var y = horizen-(height*templateSize)
		templateYs.append(y)
		# Setting in the blocks
		for bx in templateSize:
			for by in templateSize*height:
				map.set_pixel(globalX+bx, horizen-by, solidColor)

	# Adding in the templates
	for x in size.x:
		var pasteDest = Vector2(x*templateSize, templateYs[x])
		# Checking if it should be a flat land template
		var leftFlat = templateYs[clamp(x-1, 0, size.x-1)] >= templateYs[x]
		var rightFlat = templateYs[clamp(x+1, 0, size.x-1)] >= templateYs[x]
		var isValley = !leftFlat and !rightFlat

		if (leftFlat and rightFlat) or isValley:
			if isValley: pasteDest.y -= templateSize-1
			var copyRect = Rect2(
				round(rand_range(0, flatTemplateAmount))*templateSize, 0,
				templateSize, templateSize
			)
			if rand_range(0, 1) < .5: flatTemplates.flip_x()
			map.blit_rect(flatTemplates, copyRect, pasteDest)
		else:
			# Adding height connections
			var copyRect = Rect2(
				round(rand_range(0, connectionTemplateAmount))*templateSize, 0,
				templateSize, templateSize
			)
			if !leftFlat: connectionTemplates.flip_x()
			map.blit_rect(connectionTemplates, copyRect, pasteDest)
			if !leftFlat: connectionTemplates.flip_x()

	map.save_png("user://output.png")

	return map




