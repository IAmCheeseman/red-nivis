extends Reference
class_name TempTimer


# Frame time
class FrameTimer_ extends Node:
	signal timeout

	var frames := 1

	func _ready() -> void:
		var _discard = get_tree().connect("idle_frame", self, "_on_timeout")

	func _on_timeout() -> void:
		frames -= 1
		if frames == 0:
			emit_signal("timeout")
			queue_free()

# Time real time, instead of game time
class DeltaTimer_ extends Node:
	signal timeout
	
	var timeLeft := 1.0
	
	func _process(delta: float) -> void:
		timeLeft -= delta
		if timeLeft <= 0:
			emit_signal("timeout")
			queue_free()


static func idle_frame(node:Node, frames:int=1):
	var t := FrameTimer_.new()
	t.frames = frames
	node.call_deferred("add_child", t)
	
	return t


static func timer(node:Node, time:float=1):
	var t := DeltaTimer_.new()
	t.timeLeft = time
	node.call_deferred("add_child", t)
	
	return t
