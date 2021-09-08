extends Resource
class_name FrameFreezer


var currentTimerCount = 0


func freeze_frames(time:float) -> void:
	var timer:Timer = Timer.new()
	timer.connect("timeout", self, "_timer_done", [timer])
	timer.pause_mode = Node.PAUSE_MODE_PROCESS
	
	GameManager.add_child(timer)
	
	timer.start(time)
	currentTimerCount += 1
	timer.get_tree().paused = true


func _timer_done(timer:Timer) -> void:
	currentTimerCount -= 1
	if currentTimerCount == 0: timer.get_tree().paused = false
	timer.queue_free()

