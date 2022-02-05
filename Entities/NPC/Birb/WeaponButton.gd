extends "res://UI/PauseMenu/CustomButton.gd"

var itemID: String

func setup(tex_: StreamTexture, name_: String, id: String) -> void:
	text = name_
	icon = tex_
	itemID = id
