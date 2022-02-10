extends Control

const STARTING_AREA = "res://World/StartingArea/StartingArea.tscn"
const WORLD = "res://World/WorldManagement/World.tscn"

onready var fadeOut = $ScreenTransition
onready var quitAccept = $QuitAccept


func play() -> void:
	fadeOut.out()
	yield(TempTimer.timer(self, 2.5), "timeout")
	OS.window_fullscreen = Settings.fullscreen
	var target = STARTING_AREA if GameManager.load_run() != OK else WORLD
	var _discard = get_tree().change_scene(target)


func start_quit() -> void:
	quitAccept.show()


func quit(doQuit: String) -> void:
	if doQuit == "Yes": get_tree().quit()


func to_discord() -> void:
	OS.shell_open("https://discord.gg/UrbYQU7uKv")
