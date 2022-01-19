extends KinematicBody2D

onready var sprite = $ScaleHelper/Sprite

onready var dialog = $Dialog/Dialog
onready var interactionZone = $Iteraction


var vel:Vector2 = Vector2.ZERO

signal dialog_finished


func _ready() -> void:
	dialog.hide()


func _process(delta):
	vel.y += Globals.GRAVITY*delta
	vel.y = move_and_slide(vel).y


func _on_interaction() -> void:
	dialog.show()
	dialog.start_dialog("Introduction")
	interactionZone.disabled = true


func _on_dialog_finished() -> void:
	interactionZone.disabled = false
	emit_signal("dialog_finished")
