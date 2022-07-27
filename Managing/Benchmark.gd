extends Node2D


func fib(n: int) -> int:
	if n < 2: return n
	return fib(n - 2) + fib(n - 1)

func _ready() -> void:
	var starttime = OS.get_ticks_msec()
	for i in 5:
		print(fib(28))
	print("Elapsed: %s" % str(float(OS.get_ticks_msec() - starttime) / 1000.0))
