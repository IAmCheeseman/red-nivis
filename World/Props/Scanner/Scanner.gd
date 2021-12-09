extends Node2D

onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var shakeTimer = $ShakeTimer
onready var interaction = $Iteraction
onready var itemSpawn = $ItemSpawn

var ending := false
var worldPos = GameManager.worldData.position
var roomData = GameManager.worldData.rooms\
	[worldPos.x][worldPos.y].nodeData
var key

func _ready() -> void:
	key = str(get_index())
	if !roomData.has(key):
		roomData[str(get_index())] = false
	else:
		interaction.disabled = roomData[str(get_index())]


func _on_interaction() -> void:
	anim.play("BuildUp")
	GameManager.emit_signal(
		"zoom_in", .75, 2,
		global_position-Vector2(0, sprite.texture.get_height()/2/sprite.vframes)
	)
	interaction.disabled = true
	roomData[key] = true


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "BuildUp" and !ending:
		anim.play("Shake")
		shakeTimer.start()
	elif ending:
		ending = false
		anim.play("RESET")


func _on_shake_timer_timeout() -> void:
	GameManager.emit_signal("screenshake", 2, 4, .025, .025*3)
	anim.play_backwards("BuildUp")
	itemSpawn.add_item()
	ending = true
