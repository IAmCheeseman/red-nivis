extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var image = RoomGenerator.generate(randi(), "res://World/Templates/LabTemplates/", 11, self)
	var tex = ImageTexture.new()
	tex.create_from_image(image)
	$Sprite.texture = tex
