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
	var size:Vector2 = Vector2(rand_range(1, 3), rand_range(1, 3)).round()
	var image:Image = Image.new()
	image.create(
		int(size.x*TEMPLATE_SIZE), 
		int(size.y*TEMPLATE_SIZE), 
		true, Image.FORMAT_RGBA8)
	
	var templates:Image = _templates.get_data()
	
	var upExitI = round(rand_range(1, size.x))
	var downExitI = round(rand_range(1, size.x))
	var rightExitI = round(rand_range(1, size.y))
	var leftExitI = round(rand_range(1, size.y))
	
	image.lock()
	for x in size.x:
		for y in size.y:
			var template = get_random_template(templates, templateAmount)
			var room = templates.get_rect(template.solids)
			var platforms = templates.get_rect(template.platforms)
			room.lock()
			platforms.lock()
			
			# Adding the template
			for xx in room.get_width():
				for yy in room.get_height():
					var color:Color = room.get_pixel(xx, yy)
					var pColor = platforms.get_pixel(xx, yy)
					var pixelDir := get_tile_dir(color)
					
					# Determining the color
					if (pixelDir == IS_UP and y != 0)\
					or (pixelDir == IS_UP and x == upExitI-1 and y == 0 and Vector2.UP in exits):
						color = EMPTY
					elif (pixelDir == IS_DOWN and y != size.y-1)\
					or (pixelDir == IS_DOWN and x == downExitI-1 and y == size.y-1 and Vector2.DOWN in exits):
						color = EMPTY
					elif (pixelDir == IS_RIGHT and x != size.x-1)\
					or (pixelDir == IS_RIGHT and y == rightExitI-1 and x == size.x-1 and Vector2.RIGHT in exits):
						color = EMPTY
					elif (pixelDir == IS_LEFT and x != 0)\
					or (pixelDir == IS_LEFT and y == leftExitI-1 and x == 0 and Vector2.LEFT in exits):
						color = EMPTY
					elif color.is_equal_approx(EMPTY):
						color = EMPTY
					else:
						color = TILE
					if (pColor.is_equal_approx(UP) or pColor.is_equal_approx(DOWN) or pColor.is_equal_approx(TILE))\
					and !color.is_equal_approx(TILE):
						color = PLATFORM
					
					image.set_pixel(
						xx+(x*TEMPLATE_SIZE),
						yy+(y*TEMPLATE_SIZE),
						color
					)
			room.unlock()
			platforms.unlock()
	
	image.unlock()
	
	return image


static func get_random_template(template:Image, templateAmount:int) -> Dictionary:
# warning-ignore:integer_division
	var templatex := int(rand_range(0, (template.get_width()/(templateAmount-1))))*TEMPLATE_SIZE
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
