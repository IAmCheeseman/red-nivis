extends Node

# Main Area
export var depth:int = 10
export var templateHeight:int = 19
export var templateAmount:int = 1
export var outTemplateAmount:int = 1
export var templatesPath:String = "res://World/LabRuins/"
export var templateFileName:String = "Template%s.tscn"
export var outTemplateFileName:String = "OutTemplate%s.tscn"

# Walker
export var branchAmount:int = 5
export var branchPath:String = "res://World/Caves/"
export var branchTemplateAmount = 1

# Tiles
export var solidsPath:NodePath
export var bgPath:NodePath
export var platformsPath:NodePath
export var propsPath:NodePath
export var stonePath:NodePath 
export var worldNode:NodePath

var worldWidth = 0


func generate_world() -> void:
	# Lab Generation
	for x in depth:
		var offset = x*templateHeight
		
		var templatePath = templatesPath+templateFileName % round(rand_range(1, templateAmount))
		var selectedTemplate = load(templatePath)
		
		add_template_to_world(selectedTemplate.instance(), offset)
	worldWidth = get_node(solidsPath).get_used_rect().end.x-1
	
	# Adding Exit
	var offset = depth*templateHeight
	
	var templatePath = templatesPath+outTemplateFileName % round(rand_range(1, outTemplateAmount))
	var selectedTemplate = load(templatePath)
	
	add_template_to_world(selectedTemplate.instance(), offset)

	pad()
	generate_branches()


func pad() -> void:
	var solids:TileMap = get_node(solidsPath)
	var rect = solids.get_used_rect()
	var left = rect.position.x
	var right = rect.end.x-1
	var bottom = rect.end.y-1
	
	for y in rect.end.y:
		for i in 3:
			solids.set_cell(left-i, y, 0)
			solids.set_cell(right+i, y, 0)
			solids.update_bitmask_area(Vector2(left-i, y))
			solids.update_bitmask_area(Vector2(right+i, y))
	for x in rect.end.x:
		for i in 6:
			if solids.get_cell(x, bottom) != -1:
				solids.set_cell(x, bottom+i, 0)
				solids.set_cell(x, bottom+i, 0)
				solids.update_bitmask_area(Vector2(x, bottom+i))
				solids.update_bitmask_area(Vector2(x, bottom+i))


func generate_branches():
	var stone:TileMap = get_node(stonePath)
	var lab:TileMap = get_node(solidsPath)
	var world = get_node(worldNode)
	
	var branchAreas:Array = []
	
	for cb in branchAmount:
		var selection:int = round(rand_range(1, branchTemplateAmount))
		var selectedBranch:PackedScene = load(branchPath+templateFileName % selection)
		var newBranch:Node2D = selectedBranch.instance()
		
		# Getting my nodes :>
		var branchStone:TileMap = newBranch.get_node("Stone")
		var branchRemoval:TileMap = newBranch.get_node("LabTileRemoval")
		var labTiles:TileMap = newBranch.get_node("LabSolids")
		var containers:Node2D = newBranch.get_node("Containers")
		var enemies:Node2D = newBranch.get_node("Enemies")
		var camMoveZone:Area2D = newBranch.get_node("CameraMoveZone")
		
		var offset = get_offset()
		
		var rect = branchStone.get_used_rect()
		rect.position -= Vector2.ONE
		rect.end += Vector2.ONE*2
		
		var attempts = 0
		while true:
			var done = true
			var checkRect = rect
			checkRect.position += offset
			for r in branchAreas:
				if r.intersects(checkRect):
					offset = get_offset()
					done = false
					break
			if done or attempts == 100:
				break
			attempts += 1
		if attempts == 100: continue
		rect.position += offset
		
		var leftSide = offset.x != worldWidth
		
		if !leftSide:
			camMoveZone.position.x = -camMoveZone.position.x
		
		newBranch.remove_child(camMoveZone)
		world.add_child(camMoveZone)
		camMoveZone.position += offset*stone.cell_size.x

		# Adding stone
		for tile in branchStone.get_used_cells():
			var t = tile
			t.x = -t.x if !leftSide else t.x
			stone.set_cellv(t+offset, branchStone.get_cellv(tile))
			stone.update_bitmask_area(t+offset)
			lab.set_cellv(t+offset, -1)
			lab.update_bitmask_area(t+offset)
		
		# Adding labtiles
		for tile in labTiles.get_used_cells():
			var t = tile
			t.x = -t.x if !leftSide else t.x
			lab.set_cellv(t+offset, labTiles.get_cellv(tile))
			lab.update_bitmask_area(t+offset)
		
		# Removing tiles
		for tile in branchRemoval.get_used_cells():
			var t = tile
			t.x = -t.x if !leftSide else t.x
			lab.set_cellv(t+offset, -1)
			lab.update_bitmask_area(t+offset)
		
		# Adding containers
		for c in containers.get_children():
			containers.remove_child(c)

			c.z_index = -1
			c.position.x = -c.position.x if !leftSide else c.position.x
			c.position += offset*stone.cell_size.x
			world.add_child(c)
			
		for e in enemies.get_children():
			enemies.remove_child(e)

			e.z_index = -1
			e.position.x = -e.position.x if !leftSide else e.position.x
			e.position += offset*stone.cell_size.x
			world.add_child(e)
			e.spawn_enemy(round(rand_range(4, 8)))
		
		branchAreas.append(rect)
		
		newBranch.queue_free()

# Gets an offset for the `generate_branches()` function
func get_offset() -> Vector2:
	var offset:Vector2 = Vector2(0, rand_range(0, (depth*templateHeight)-templateHeight)).round()
	if rand_range(0, 1) > .5:
		offset.x = worldWidth
	return offset


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
	
	for e in template.enemies.get_children():
		template.enemies.remove_child(e)
		e.position.y += offset*16
		e.z_index = -1
		get_node(worldNode).add_child(e)
		
		e.spawn_enemy(round(rand_range(1, 3)))
	
	template.queue_free()


func copy_tiles(from:TileMap, to:TileMap, offset:int) -> void:
	var tiles = from.get_used_cells()
	for t in tiles:
		var vec = t+Vector2.DOWN*offset
		to.set_cellv(vec, from.get_cellv(t))
		to.update_bitmask_area(vec)
