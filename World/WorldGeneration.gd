extends Node

export var depth:int = 10
export var templateHeight:int = 19
export var templateAmount:int = 1
export var templatesPath:String = "res://World/LabRuins/"
export var templateFileName:String = "Template%s.tscn"
export var solidsPath:NodePath
export var bgPath:NodePath
export var platformsPath:NodePath
export var propsPath:NodePath
export var worldNode:NodePath


func generate_world() -> void:
	for x in depth:
		var offset = x*templateHeight
		
		var templatePath = templatesPath+templateFileName % round(rand_range(1, templateAmount))
		var selectedTemplate = load(templatePath)
		
		add_template_to_world(selectedTemplate.instance(), offset)
	pad()


func pad() -> void:
	var solids:TileMap = get_node(solidsPath)
	var rect = solids.get_used_rect()
	var left = rect.position.x
	var right = rect.end.x-1
	
	for y in rect.end.y:
		for i in 3:
			solids.set_cell(left-i, y, 0)
			solids.set_cell(right+i, y, 0)
			solids.update_bitmask_area(Vector2(left-i, y))
			solids.update_bitmask_area(Vector2(right+i, y))


func add_template_to_world(template:Node2D, offset:int) -> void:
	add_child(template)
	
	copy_tiles(template.solids, get_node(solidsPath), offset)
	copy_tiles(template.bg, get_node(bgPath), offset)
	copy_tiles(template.platforms, get_node(platformsPath), offset)
	copy_tiles(template.props, get_node(propsPath), offset)
	
	for c in template.containers.get_children():
		template.containers.remove_child(c)
		
		c.position.y += offset*16
		c.z_index = -1
		get_node(worldNode).add_child(c)
	
	template.queue_free()


func copy_tiles(from:TileMap, to:TileMap, offset:int) -> void:
	var tiles = from.get_used_cells()
	for t in tiles:
		var vec = t+Vector2.DOWN*offset
		to.set_cellv(vec, from.get_cellv(t))
		to.update_bitmask_area(vec)
