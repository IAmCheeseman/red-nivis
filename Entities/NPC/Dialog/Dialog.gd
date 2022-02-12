extends Control


export var dialog:Resource
export var pointerOffset := 15
export var advanceTime := 3.0
export var talkingSpeed := 0.05
export var font: Font = null

onready var text = $Text
onready var background = $Background
onready var pointer = $Pointer
onready var advanceTimer = $AdvanceTimer
onready var charIncTimer = $CharIncTimer
onready var speakSound = $Bleep

const MAX_SIZE = 120

#var dialogIst:AnimationPlayer
var currentDialogID := ""
var targetText := ""
var charsShown = 0
var currentDialog = 1
var finished = false

signal done


func _ready() -> void:
	if font: text.add_font_override("normal_font", font)


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
	background.rect_size.y = text.rect_size.y + 4
	background.rect_position = -background.rect_size*.5
	background.rect_position.y = -background.rect_size.y
	
	# Pointer
	pointer.position.x = 0
	
	# Label
	text.rect_size.x = background.rect_size.x
	text.rect_position = background.rect_position + Vector2(0, (size.y/2)-2)


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
	
	if text.bbcode_text.length() == testText.length():
		text.bbcode_text = add_center_tags(targetText)
		finished = true
		advanceTimer.start(advanceTime)
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
	
	# Finishing
	if currentDialog >= currentInteraction.size():
		hide()
		emit_signal("done")
		currentDialogID = ""
		return
	
	# Starting
	targetText = currentInteraction[currentDialog]
	charIncTimer.start(talkingSpeed)


