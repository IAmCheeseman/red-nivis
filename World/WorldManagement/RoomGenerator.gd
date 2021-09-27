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


static func generate(seed_:int, templatesName:String, templateAmount:int) -> Image:
	seed(seed_)
	var size:Vector2 = Vector2(rand_range(2, 2), rand_range(2, 2)).round()
	var image:Image = Image.new()
	image.create(int(size.x*TEMPLATE_SIZE), int(size.y*TEMPLATE_SIZE), true, Image.FORMAT_RGBA8)
	
	var templates = load(TEMPLATE_PATH+templatesName)
	
	image.lock()
	for x in size.x:
		for y in size.y:
			var template = get_random_template(templates, templateAmount)
			image.blit_rect(image, template.solids, Vector2(x*TEMPLATE_SIZE, y*TEMPLATE_SIZE))
	image.unlock()
	
	return image


static func get_random_template(template:StreamTexture, templateAmount:int) -> Dictionary:
	var image := template.get_data()
# warning-ignore:integer_division
	var templatex := int(rand_range(0, image.get_width()/templateAmount))*TEMPLATE_SIZE
	
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

