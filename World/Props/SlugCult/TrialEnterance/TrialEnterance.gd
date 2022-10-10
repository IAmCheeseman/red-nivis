extends Node2D

onready var sprite = $Sprite
onready var hologram = $Hologram


export var trial: PackedScene
export var reward: Resource = preload("res://Items/Upgrades/Teleport/Teleport.tres")


func _ready() -> void:
	hologram.texture = reward.hologramSprite


func new_frame() -> void:
	var frames = range(0, sprite.hframes)
	frames.shuffle()
	while true:
		var frame = frames.pop_front()
		if frame == sprite.frame:
			continue
		sprite.frame = frame
		break


func _on_interaction() -> void:
	var _discard = get_tree().change_scene_to(trial)
