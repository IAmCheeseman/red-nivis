extends Node
class_name RoomGenerator

const TEMPLATE_SIZE = 10

const EMPTY = Color("#ffffff")
const TILE = Color("#000000")
const PLATFORM = Color("#3b486d")
const UP = Color("#5bb031")
const DOWN = Color("#e089e0")
const RIGHT = Color("#75d1e4")
const LEFT = Color("#952008")

enum {IS_UP, IS_DOWN, IS_RIGHT, IS_LEFT, IS_TILE}


static func generate(seed_:int, _templates:StreamTexture, templateAmount:int, exits:PoolVector2Array) -> Image:
	seed(seed_)
	var size:Vector2 = Vector2(rand_range(2, 3), rand_range(2, 3)).round()
	while size == Vector2.ONE:
		size = Vector2(rand_range(2, 3), rand_range(2, 3)).round()
	var image:Image = Image.new()
	image.create(
		int(size.x*TEMPLATE_SIZE), 
		int(size.y*TEMPLATE_SIZE), 
		true, Image.FORMAT_RGBA8)
	
	var blockOuts = []
	var blockOutCount = floor((size.x*size.y)*.5)
	
	while blockOutCount >= size.x or blockOutCount >= size.y:
		blockOutCount -= 1
	
	for i in blockOutCount:
		blockOuts.append(Vector2(
			rand_range(0, size.x),
			rand_range(0, size.y)
		).round())
	
	var templates:Image = _templates.get_data()
	
	var upExitI = round(rand_range(0, size.x-1))
	while Vector2(upExitI, 0) in blockOuts: upExitI = round(rand_range(0, size.x-1))
	var downExitI = round(rand_range(0, size.x-1))
	while Vector2(downExitI, size.y-1) in blockOuts: downExitI = round(rand_range(0, size.x-1))
	var rightExitI = round(rand_range(0, size.y-1))
	while Vector2(size.x-1, rightExitI) in blockOuts: rightExitI = round(rand_range(0, size.y-1))
	var leftExitI = round(rand_range(0, size.y-1))
	while Vector2(0, leftExitI) in blockOuts: leftExitI = round(rand_range(0, size.y-1))
	
	image.lock()
	for x in size.x:
		for y in size.y:
			var template = get_random_template(templates, templateAmount)
			if Vector2(x, y) in blockOuts:
				template.solids.position.x = templates.get_width()
				template.platforms.position.x = templates.get_width()
			var room = templates.get_rect(template.solids)
			var platforms = templates.get_rect(template.platforms)
			room.lock()
			platforms.lock()
			
			# Adding the template
			for xx in room.get_width():
				for yy in room.get_height():
					var color:Color = room.get_pixel(xx, yy)
					var pColor:Color = platforms.get_pixel(xx, yy)
					var pixelDir := get_tile_dir(color)
					
					# Determining the color
					if (pixelDir == IS_UP and y != 0)\
					or (pixelDir == IS_UP and x == upExitI and y == 0 and Vector2.UP in exits):
						color = EMPTY
					elif (pixelDir == IS_DOWN and y != size.y-1)\
					or (pixelDir == IS_DOWN and x == downExitI and y == size.y-1 and Vector2.DOWN in exits):
						color = EMPTY
					elif (pixelDir == IS_RIGHT and x != size.x-1)\
					or (pixelDir == IS_RIGHT and y == rightExitI and x == size.x-1 and Vector2.RIGHT in exits):
						color = EMPTY
					elif (pixelDir == IS_LEFT and x != 0)\
					or (pixelDir == IS_LEFT and y == leftExitI and x == 0 and Vector2.LEFT in exits):
						color = EMPTY
					elif color.is_equal_approx(EMPTY):
						color = EMPTY
					else:
						color = TILE
					
					
					if (pColor.is_equal_approx(UP) or pColor.is_equal_approx(DOWN) or pColor.is_equal_approx(TILE))\
					and !color.is_equal_approx(TILE):
						color = PLATFORM
					
#					if (pixelDir == IS_UP and Vector2(x, y-1) in blockOuts):
#						color = TILE
#					elif (pixelDir == IS_DOWN and Vector2(x, y+1) in blockOuts):
#						color = TILE
#					elif (pixelDir == IS_RIGHT and Vector2(x+1, y) in blockOuts):
#						color = TILE
#					elif (pixelDir == IS_LEFT and Vector2(x-1, y) in blockOuts):
#						color = TILE
					
					image.set_pixel(
						xx+(x*TEMPLATE_SIZE),
						yy+(y*TEMPLATE_SIZE),
						color
					)
			room.unlock()
			platforms.unlock()
	
	image.unlock()
	
	image.save_png("user://Room.png")
	return image


static func get_random_template(template:Image, templateAmount:int) -> Dictionary:
# warning-ignore:integer_division
	var templatex := int(rand_range(0, (template.get_width()/(templateAmount))))*TEMPLATE_SIZE
# warning-ignore:narrowing_conversion
	templatex = clamp(int(templatex), 0, template.get_width()-TEMPLATE_SIZE)
	
	return {
		"solids" : Rect2(
			Vector2(templatex, 0),
			Vector2(TEMPLATE_SIZE, TEMPLATE_SIZE)
		),
		"platforms" : Rect2(
			Vector2(templatex, TEMPLATE_SIZE),
			Vector2(TEMPLATE_SIZE, TEMPLATE_SIZE)
		)
	}


static func get_tile_dir(color:Color) -> int:
	match color:
		UP:
			return IS_UP
		DOWN:
			return IS_DOWN
		RIGHT:
			return IS_RIGHT
		LEFT:
			return IS_LEFT
		_:
			return IS_TILE
