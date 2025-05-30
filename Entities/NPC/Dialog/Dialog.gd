extends Control


export var npcName := "[Name]"
export var dialog:Resource
export var pointerOffset := 15
export var advanceTime := 3.0
export var talkingSpeed := 0.05
export var fontOverride: Font = null
export var autoAdvance := false

onready var text = $Text
onready var background = $Background
onready var advanceTimer = $AdvanceTimer
onready var charIncTimer = $CharIncTimer
onready var speakSound = $Bleep
onready var dialogPrompt = $AdvanceDialogPrompt
onready var nameLabel = $Name

const MAX_SIZE = 120

#var dialogIst:AnimationPlayer
var currentDialogID := ""
var targetText := ""
var charsShown = 0
var currentDialog = 1
var finished = false

signal done
signal dialog_signal(signalName)
signal timer_done(currentDialog)

var time := 0.0


func _ready() -> void:
	nameLabel.text = npcName
	if fontOverride: text.add_font_override("normal_font", fontOverride)


#func _process(delta: float) -> void:
#	get_parent().position.y += sin(time) * delta
#	rect_global_position = get_parent().global_position.round()
#	time += delta


func start_dialog(interaction:String="Introduction") -> void:
	currentDialog = 0
	currentDialogID = interaction
	
	text.text = ""
	text.rect_size.y = 0
	background.rect_size.y = 0
	reposition_bg()
	
	increment_text()
	charIncTimer.start(talkingSpeed)
	show()


func stop_dialog() -> void:
	currentDialogID = ""


func reposition_bg(resizeText: String=text.text) -> void:
	var font:Font = text.get_font("normal_font")
	
	var size := font.get_string_size(resizeText)
	# Background
	text.rect_size.y = 0
	
	# 16 just makes sure that it can completely fit the thing
	background.rect_size.x = min(size.x + 16, MAX_SIZE)
	background.rect_size.y = text.rect_size.y + 5
	background.rect_position = -background.rect_size*.5
	background.rect_position.y = -background.rect_size.y
	
	dialogPrompt.rect_position = (background.rect_position + background.rect_size) - (dialogPrompt.texture.get_size() + Vector2(3, -1))
	
	# Pointer
	
	# Label
	text.rect_size.x = background.rect_size.x
	text.rect_position = background.rect_position + Vector2(1, (size.y/2)-2)
	
	nameLabel.rect_position = -background.rect_size * Vector2(0.5, 1)
	nameLabel.rect_position.y -= nameLabel.rect_size.y / 2


func add_center_tags(string:String) -> String:
	return "[center]" + string + "[/center]"


func increment_char() -> void:
	if finished: return
	if !currentDialogID: return
	
	text.bbcode_text = targetText
	if rand_range(0, 1) < .666:
		speakSound.play()
	var testText = add_center_tags(text.text)
	text.bbcode_text = add_center_tags(text.text.left(charsShown))
	
	dialogPrompt.hide()
	if text.bbcode_text.length() == testText.length():
		text.bbcode_text = add_center_tags(targetText)
		finished = true
		
		dialogPrompt.show()
		if autoAdvance:
			advanceTimer.start()
			dialogPrompt.hide()
		return
	
	charsShown += 1
	
	reposition_bg()
	
	charIncTimer.start(talkingSpeed)
 

func increment_text() -> void:
	# Resetting 
	finished = false
	charsShown = 0
	
	var currentInteraction = dialog.get_interaction(currentDialogID)
	currentDialog += 1
	
	if currentInteraction:
		call_commands(currentInteraction)
	
	# Finishing
	if currentInteraction == null: return
	if currentDialog >= currentInteraction.size():
		hide()
		emit_signal("done")
		currentDialogID = ""
		return
	
	# Starting
	targetText = tr(currentInteraction[currentDialog])
	charIncTimer.start(talkingSpeed)


func call_commands(currentInteraction: Array) -> void:
	if currentDialog >= currentInteraction.size(): return
	var dialogText = currentInteraction[currentDialog]
	if dialogText.begins_with("s:"):
		emit_signal("dialog_signal", dialogText.replace("s:", ""))
		increment_text()
	if dialogText.begins_with("t:"):
		hide()
		yield(TempTimer.timer(self, float(dialogText.replace("t:", "")) ), "timeout")
		show()
		emit_signal("timer_done", currentDialog)
		increment_text()


func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		if charsShown == text.text.length():
			yield(TempTimer.idle_frame(self), "timeout")
			increment_text()
