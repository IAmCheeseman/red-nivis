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


static func generate(seed_:int, templates:String, templateAmount:int, node:Node) -> Image:
	seed(seed_)
	var size:Vector2 = Vector2(rand_range(1, 3), rand_range(1, 3)).round()
	var image:Image = Image.new()
	image.create(size.x*TEMPLATE_SIZE, size.y*TEMPLATE_SIZE, true, Image.FORMAT_RGBA8)
	
	var templatePath = TEMPLATE_PATH+templates
	
	
	return image


static func get_random_template(template:StreamTexture, templateAmount:int):
	var image := template.get_data()
	return {
		"solids" : image.get_rect(
			Rect2(
				Vector2(rand_range(0, image.get_width()/templateAmount), 0),
				Vector2(TEMPLATE_SIZE, TEMPLATE_SIZE)
			)
		),
		"platforms" : image.get_rect(
			Rect2(
				Vector2(rand_range(0, image.get_width()/templateAmount), TEMPLATE_SIZE),
				Vector2(TEMPLATE_SIZE, TEMPLATE_SIZE)
			)
		)
	}

