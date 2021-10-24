extends Control


export var dialog:PackedScene
export var pointerOffset := 15
export var advanceTime := 3.0

onready var text = $Text
onready var background = $Background
onready var pointer = $Pointer
onready var advanceTimer = $AdvanceTimer
onready var charIncTimer = $CharIncTimer

var dialogIst:AnimationPlayer
var currentDialogID := ""
var targetText := ""
var charsShown = 0
var currentDialog = -.1
var finished = false

signal done


func start_dialog(interaction:String="Introduction") -> void:
	set_dialog()
	currentDialog = -.1
	currentDialogID = interaction
	
	text.text = ""
	reposition_bg()
	
	increment_text()
	charIncTimer.start()


func set_dialog():
	if dialogIst:
		return
	dialogIst = dialog.instance()
	add_child(dialogIst)


func reposition_bg() -> void:
	var font:Font = text.get_font("normal_font")
	
	var size := font.get_string_size(text.text)
	# Background
	background.rect_size.x = size.x + 16
	background.rect_position.x = -background.rect_size.x*.5
	
	# Pointer
	pointer.position.x = 0
	
	# Label
	text.rect_size.x = background.rect_size.x
	text.rect_position.x = background.rect_position.x


func add_center_tags(string:String) -> String:
	return "[center]" + string + "[/center]"


func increment_char() -> void:
	if finished: return
	
	text.bbcode_text = targetText
	var testText = add_center_tags(text.text)
	text.bbcode_text = add_center_tags(text.text.left(charsShown))
	
	if text.bbcode_text.length() == testText.length():
		text.bbcode_text = add_center_tags(targetText)
		finished = true
		advanceTimer.start(advanceTime)
		return
	
	charsShown += 1
	reposition_bg()


func increment_text() -> void:
	# Resetting 
	finished = false
	charsShown = 0
	
	# Starting
	dialogIst.play(currentDialogID)
	
	currentDialog += .1
	dialogIst.seek(currentDialog, true)
	
	if dialogIst.has_node("DialogHolder"):
		if currentDialog >= dialogIst.current_animation_length:
			hide()
			emit_signal("done")
			return
		
		var dialogHolder = dialogIst.get_node("DialogHolder")
		dialogHolder.hide()
		targetText = dialogHolder.text
		
		charIncTimer.start()
	else:
		push_error("No dialog holder to read or misnamed")

