extends Node2D

onready var stands = $TileMap


const GNOMES = preload("res://Entities/Enemies/Bosses/Gnome/Crowd/Gnomes.png")

var currentSeed = 0
var currentBounces = []
var addBounces = true
var dt:float = 0.0

func _process(delta: float) -> void:
	dt = delta
	update()


func _draw() -> void:
	var id = 0
	for i in stands.get_used_cells():
		var frameCount = Vector2(3, 4)
		var spriteSize = GNOMES.get_size()
		var frameSize = (spriteSize / frameCount)
		
		var drawRect = Rect2(0,0,0,0)
		seed(i.x * i.y)
		drawRect.position = Vector2(
			(spriteSize.x - frameSize.x) * rand_range(0, 1),
			(spriteSize.y - frameSize.y) * rand_range(0, 1)
		).snapped(frameSize)
		print(drawRect.position)
		drawRect.size = frameSize
		
		var positionRect = Rect2(
			stands.map_to_world(i) - Vector2(0, frameSize.y),
			frameSize
		)
		
		seed(currentSeed + (i.x * i.y))
		positionRect.position -= Vector2(0, int(Utils.coin_flip()) * rand_range(1, 3))
		drawRect.size.x *= -1 if Utils.coin_flip() else 1
		
		if addBounces:
			currentBounces.append(positionRect.position.y)
		else:
			currentBounces[id] = lerp(currentBounces[id], positionRect.position.y, 24 * dt)
			positionRect.position.y = currentBounces[id]
		
		draw_texture_rect_region(GNOMES, positionRect, drawRect)
		
		id += 1
	addBounces = false


func _on_timeout() -> void:
	currentSeed += 1
