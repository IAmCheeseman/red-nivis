extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() != "Linux": queue_free()


func _process(delta: float) -> void:
	var timer = get_tree().create_timer(.1)
	timer.connect("timeout", self, "_on_timeout")
	get_tree().paused = true


func _on_timeout() -> void: get_tree().paused = false

