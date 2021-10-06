extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var image = RoomGenerator.generate(randi(), "LabTemplates.png", 11)
	var tex = ImageTexture.new()
	tex.create_from_image(image)
	$Sprite.texture = tex
