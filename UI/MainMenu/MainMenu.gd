extends Node2D

onready var title = $Menu/TitleControl/Title
onready var titleControl = $Menu/TitleControl
onready var anim = $AnimationPlayer
onready var menu = find_node("UI")
onready var startButton = find_node("StartButton")


func _ready() -> void:
	title.position.x = titleControl.rect_size.x / 2
	title.position.y = titleControl.rect_size.y / 2


func start() -> void:
	anim.play("Start")
	startButton.disabled = true
	yield(TempTimer.timer(self, .8), "timeout")
	var tween = Tween.new()
	add_child(tween)
	menu.show()
	tween.interpolate_property(
		menu, "modulate",
		Color.transparent, Color.white,
		1.1
	)
	tween.start()

