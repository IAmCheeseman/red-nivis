extends Node
class_name RoomGenerator

const TEMPLATE_SIZE = 16


static func generate(seed_:int, path:String, templateAmount:int, node:Node) -> Image:
	seed(seed_)
	var size:Vector2 = Vector2(rand_range(1, 3), rand_range(1, 3)).round()
	var image:Image = Image.new()
	image.create(size.x*TEMPLATE_SIZE, size.y*TEMPLATE_SIZE, true, Image.FORMAT_RGBA8)
	
	var templatePath = path+"Template%s.tscn"
	
	
	image.lock()
	for x in size.x:
		for y in size.y:
			var template = load(templatePath % round(rand_range(1, templateAmount))).instance()
			node.add_child(template)
			for c in template.tiles.get_used_cells():
				image.set_pixel((x*TEMPLATE_SIZE)+c.x, (y*TEMPLATE_SIZE)+c.y, Color.white)
			template.queue_free()
	image.unlock()
	
	return image
	
	

