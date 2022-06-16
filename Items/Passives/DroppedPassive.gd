extends RigidBody2D

onready var sprite=  $Sprite
onready var guiAnim = $CanvasLayer/Info/AnimationPlayer
onready var guiName = $CanvasLayer/Info/Name
onready var guiDesc = $CanvasLayer/Info/Desc
onready var gui = $CanvasLayer/Info


export var item: Resource


func _ready() -> void:
	sprite.texture = item.sprite
	guiName.text = item.name
	guiDesc.text = item.desc
	
	gui.rect_size.x = get_viewport_rect().end.x
	gui.rect_pivot_offset.x = gui.rect_size.x / 2


func _on_interaction() -> void:
	var player = preload("res://Entities/Player/Player.tres")
	player.passives.append({
		"item" : item.resource_path,
		"used" : false
	})
	player.damageMod += 0.02
	player.playerObject.update_passives()
	
	queue_free()


func _on_player_close() -> void:
	guiAnim.play("In")


func _on_player_left() -> void:
	guiAnim.play_backwards("In")
