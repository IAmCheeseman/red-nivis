extends Control

onready var label = $Tooltips

onready var startPos = label.rect_position.y

func center_correctly():
	label.rect_position.y = startPos-label.rect_size.y/2
