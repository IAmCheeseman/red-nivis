extends Node
class_name RoomGenerator

const TEMPLATE_SIZE = 10
const TEMPLATE_PATH = "res://World/Templates/"

const EMPTY = Color("#ffffff")
const TILE = Color("#000000")
const UP = Color("#5bb031")
const DOWN = Color("#e089e0")
const RIGHT = Color("#75d1e4")
const LEFT = Color("#952008")

enum {IS_UP, IS_DOWN, IS_RIGHT, IS_LEFT, IS_TILE}


static func generate(seed_:int, templatesName:String, templateAmount:int) -> Image:
	seed(seed_)
	var size:Vector2 = Vector2(rand_range(1, 3), rand_range(1, 3)).round()
	var image:Image = Image.new()
	image.create(int(size.x*TEMPLATE_SIZE), int(size.y*TEMPLATE_SIZE), true, Image.FORMAT_RGBA8)
	
	var templates:Image = load(TEMPLATE_PATH+templatesName).get_data()
	
	var canBlockOffy = size.x != 1
	var canBlockOffx = size.y != 1
	if canBlockOffx: canBlockOffx = size != Vector2.ONE*2
	if canBlockOffy: canBlockOffy = size != Vector2.ONE*2
	var blocksy = 0
	var blocksx = 0
	
	image.lock()
	for x in size.x:
		for y in size.y:
			var template = get_random_template(templates, templateAmount)
			var room = templates.get_rect(template.solids)
			room.lock()
			
			# Deciding whether or not to block off this template in a certain direction
			var blockDir = int(rand_range(0, 3))
			var doBlock = rand_range(0, 1) < .5
			
			match blockDir in [IS_RIGHT, IS_LEFT]:
				true:
					if !canBlockOffx or blocksx > size.y-1:
						doBlock = false
					else:
						blocksx += 1
				false:
					if !canBlockOffy or blocksy > size.x-1:
						doBlock = false
					else:
						blocksy += 1
			
			# Adding the template
			for xx in room.get_width():
				for yy in room.get_height():
					var color:Color = room.get_pixel(xx, yy)
					var pixelDir := get_tile_dir(color)
					
					if pixelDir == IS_UP and y != 0:
						color = EMPTY
					elif pixelDir == IS_DOWN and y != size.y-1:
						color = EMPTY
					elif pixelDir == IS_RIGHT and x != size.x-1:
						color = EMPTY
					elif pixelDir == IS_LEFT and x != 0:
						color = EMPTY
					elif color.is_equal_approx(EMPTY):
						color = EMPTY
					else:
						color = TILE
					
					if doBlock and pixelDir == blockDir:
						color = TILE
					
					image.set_pixel(
						xx+(x*TEMPLATE_SIZE),
						yy+(y*TEMPLATE_SIZE),
						color
					)
		
			room.unlock()
			
	image.unlock()
	
	return image


static func get_random_template(template:Image, templateAmount:int) -> Dictionary:
# warning-ignore:integer_division
	var templatex := int(rand_range(0, template.get_width()/templateAmount))*TEMPLATE_SIZE
	
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
