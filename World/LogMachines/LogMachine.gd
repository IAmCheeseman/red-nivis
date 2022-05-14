extends Node2D

onready var ui = find_node("Screen")
onready var content = find_node("Content")
onready var closePrompt = find_node("ClosePrompt")
onready var textIncTimer = $TextIncTimer
onready var printSFX = $PrintSFX

export var manualLog: Resource

var selectedLog: Resource
var started := false

var disableQuit := false


func _ready() -> void:
	ui.hide()
	var worldData = GameManager.worldData
	seed((worldData.position.x - worldData.position.y) + worldData.worldSeed)
	
	selectedLog = load(LogList.LOGS[ceil(rand_range(-1, LogList.LOGS.size()-1))])
	if manualLog: selectedLog = manualLog


func start() -> void:
	var date = "%s/%s/%s" % [selectedLog.day, selectedLog.month, selectedLog.year]
	var text = "> Entered by %s.\n> %s\n\n> %s" % [tr(selectedLog.logger), date, tr(selectedLog.text)]
	
	content.visible_characters = 0
	closePrompt.visible_characters = 0
	content.text = text
	
	yield(TempTimer.timer(self, 1), "timeout")
	started = true
	textIncTimer.start(.05)


func _input(event: InputEvent) -> void:
	for i in ["jump", "skip_dialog"]:
		if event.is_action_pressed(i):
			content.visible_characters = -1
	
	if !ui.visible: return
	if disableQuit:
		disableQuit = false
		return
	
	for i in ["interact", "pause", "close_terminal"]:
		if event.is_action_pressed(i):
			ui.hide()
			yield(TempTimer.idle_frame(self), "timeout")
			GameManager.inGUI = false


func inc_text() -> void:
	if content.visible_characters == -1 or !started: return
	
	var strippedText = content.text
	strippedText = strippedText.replace("\n", "")
	strippedText = strippedText.replace(" ", "")
	
	if content.visible_characters < strippedText.length():
		content.visible_characters += 1
		
		if strippedText[content.visible_characters-1] in ". ? !".split(" "):
			textIncTimer.start(.5)
		else:
			textIncTimer.start(.05)
		
		if ui.visible and rand_range(0,1) < .5: printSFX.play()
	else:
		closePrompt.visible_characters += 1
		textIncTimer.start(.05)
		


func _on_interaction() -> void:
	start()
	ui.show()
	GameManager.inGUI = true
	disableQuit = true
