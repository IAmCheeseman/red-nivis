extends Resource
class_name FrameFreezer

var gm
var currentTimerCount = 0


func freeze_frames(time:float) -> void:
	var timer:Timer = Timer.new()
	var _ok = timer.connect("timeout", self, "_timer_done", [timer])
	timer.pause_mode = Node.PAUSE_MODE_PROCESS
	
	gm.add_child(timer)
	
	timer.start(time)
	currentTimerCount += 1
	
	timer.get_tree().paused = true
	VisualServer.set_shader_time_scale(0)


func _timer_done(timer:Timer) -> void:
	currentTimerCount -= 1
	if currentTimerCount == 0:
		timer.get_tree().paused = false
		VisualServer.set_shader_time_scale(1)
	timer.queue_free()
	

