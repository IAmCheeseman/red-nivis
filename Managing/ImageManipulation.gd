extends Resource
class_name ImageManipulation


func draw_circle(img:Image, dst:Vector2, size:Vector2, color:Color):
	img.lock()
	var circleImg:Image = preload("res://Managing/Circle.png").get_data()
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	circleImg.resize(size.x, size.y, Image.INTERPOLATE_NEAREST)
	circleImg.convert(img.get_format())

	circleImg.lock()
	for x in circleImg.get_width():
		for y in circleImg.get_height():
			if !is_equal_approx(circleImg.get_pixel(x, y).a, 0):
				circleImg.set_pixel(x, y, color)
			else:
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
				circleImg.set_pixel(x, y, img.get_pixel(
					clamp(x+dst.x, 0, img.get_width()-1),
					clamp(y+dst.y, 0, img.get_height()-1)
					))
	img.blit_rect(circleImg, Rect2(Vector2.ZERO, circleImg.get_size()), dst)

	img.unlock()
	circleImg.unlock()


func draw_rectangle(img:Image, dst:Rect2, color:Color):
	img.lock()
	for x in dst.end.x:
		for y in dst.end.y:
			img.set_pixelv(Vector2(x, y)+dst.position, color)
	img.unlock()
