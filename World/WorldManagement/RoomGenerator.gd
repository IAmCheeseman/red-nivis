extends Node
class_name RoomGenerator

const TEMPLATE_SIZE = 16


static func generate(seed_:int, path:String, templateAmount:int, node:Node) -> Image:
	seed(seed_)
	var size:Vector2 = Vector2(rand_range(1, 3), rand_range(1, 3)).round()
	var image:Image = Image.new()
	image.create(size.x*TEMPLATE_SIZE, size.y*TEMPLATE_SIZE, true, Image.FORMAT_RGBA8)
	
	var templatePath = path+"Templates.png"
	
	
	return image
	
	

