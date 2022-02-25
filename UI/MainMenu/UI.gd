extends Control

const STARTING_AREA = "res://World/StartingArea/StartingArea.tscn"
const WORLD = "res://World/WorldManagement/World.tscn"

onready var fadeOut = $ScreenTransition
onready var quitAccept = $QuitAccept
onready var newGameAccept = $NewGameAccept


func _ready() -> void:
	GameManager.rpBiome = "Main Menu"
	GameManager.rpGun   = "No Gun"
	GameManager.update_rp()


func play() -> void:
	fadeOut.out()
	yield(TempTimer.timer(self, 2.5), "timeout")
	var target = STARTING_AREA if GameManager.load_run() != OK else WORLD
	if target == WORLD:
		if GameManager.worldData.rooms.size() == 0:
			target = STARTING_AREA
			GameManager.clear_run()
	var _discard = get_tree().change_scene(target)


func new_game() -> void:
	newGameAccept.show()

func _on_new_game_confirm(option) -> void:
	if option != "Yes": return
	GameManager.clear_run()
	play()


func start_quit() -> void:
	quitAccept.show()


func quit(doQuit: String) -> void:
	if doQuit == "Yes": get_tree().quit()


func to_discord() -> void:
	var _discard = OS.shell_open("https://discord.gg/UrbYQU7uKv")





