extends Resource
class_name WorldGenerator

func generate_world(size:Vector2,
					horizen:int,
					elevationNoise:OpenSimplexNoise,
					flatTemplates:Image,
					connectionTemplates:Image,
					caveSizeCurve:Curve,
					minibiomes:Array) -> Image:
	randomize()
	elevationNoise.seed = randi()

	# Defining colors
	var solidColor := Color("#000000")
	var emptyColor := Color("#ffffff")
	var wallColor := Color("#34315b")

	# Creating a global size
	var templateSize:float = 16
	var globalSize = size*templateSize

	# Getting the templates
	# Getting the template amounts
	var flatTemplateAmount := flatTemplates.get_width()/templateSize
	var connectionTemplateAmount := connectionTemplates.get_width()/templateSize
	flatTemplateAmount -= 1
	connectionTemplateAmount -= 1
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
		var templateY = templateYs[x]
		var pasteDest = Vector2(x*templateSize, templateY)
		# Checking if it should be a flat land template
		var leftFlat = templateYs[clamp(x-1, 0, size.x-1)] >= templateY
		var rightFlat = templateYs[clamp(x+1, 0, size.x-1)] >= templateY
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

	# Adding caves
	var caveNoise = BorderedSimplexNoise.new()
	caveNoise.thickness = caveSizeCurve.interpolate_baked(0)
	for x in map.get_width():
		for y in map.get_height():
			caveNoise.thickness = caveSizeCurve.interpolate_baked(float(y)/float(map.get_height()))
			if caveNoise.get_noise_2d(x, y) > .5 and map.get_pixel(x, y).is_equal_approx(solidColor):
				map.set_pixel(x, y, wallColor)

	GameManager.worldLayers = {
		"Sky" : -16,
		"Surface" : horizen-(map.get_height()*.3),
		"Underground" : map.get_height()*.55,
		"Caverns" : map.get_height()*.8
	}
	print(GameManager.worldLayers)

	for mb in minibiomes:
		if mb is Minibiome:
			for nmb in 50:
				if rand_range(0, 1) > mb.rarity:
					continue

				var mbScriptNode = Node.new()
				mbScriptNode.set_script(mb.generationScript)
				mbScriptNode.minibiome = mb
				mbScriptNode.map = map

				mbScriptNode.generate_biome()

				mbScriptNode.queue_free()

	map.unlock()

	var _error = map.save_png("user://output.png")

	return map

