extends Node2D

export var color := Color("#4f8fba")
export var size := 5.0


func _draw() -> void:
	randomize()
	var branches = rand_range(2, 4)
	var mainBendMax = rand_range(3, 12)
	var maxSegLenth = rand_range(8, 12)
	var drawPos = Vector2.ZERO
	var drawAngle = rand_range(0, 360)
	var currentColor = color
	
	var segPositions = [] 
	
	for i in branches:
		var endPos = Vector2.RIGHT.rotated(deg2rad(drawAngle))
		endPos *= rand_range(5, maxSegLenth)
		endPos += drawPos
		draw_line(drawPos, endPos, currentColor, size, false)
		
		segPositions.append({
			"pos" : drawPos,
			"color" : currentColor
			})
		
		drawAngle += rand_range(-mainBendMax, mainBendMax)
		drawPos = endPos
		
		currentColor = currentColor.lightened((1/branches)*.25)
		
	for i in segPositions:
		var branchAmount = rand_range(1, 2)
		drawPos = i.pos
		currentColor = i.color
		
		for b in branchAmount:
			var branchSegs = rand_range(1, 2)
			drawAngle = rand_range(0, 360)
			drawPos = i.pos
			
			for s in branchSegs:
				var endPos = Vector2.RIGHT.rotated(deg2rad(drawAngle))
				endPos *= rand_range(5, maxSegLenth)
				endPos += drawPos
				draw_line(drawPos, endPos, currentColor, size, false)
				
				drawAngle += rand_range(-mainBendMax, mainBendMax)
				
				currentColor = currentColor.lightened((1/branchSegs)*.25)
				drawPos = endPos
