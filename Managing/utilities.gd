extends Reference
class_name Utils


static func percentage_of(a:float, b:float):
	if a == 0 or b == 0:
		return 0.0
	return (a/b)*100


static func percentage_from(percent:float, a:float):
	if percent == 0 or a == 0:
		return 0.0
	var tinyPercent = 100/percent
	return a/tinyPercent


static func is_even(number:int): return !(number % 2)


static func free_children(node:Node):
	for i in node.get_children():
		i.queue_free()
