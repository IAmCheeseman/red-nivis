extends Node2D

onready var parrySign = $Props/ParrySign
onready var parrySignAnim = $Props/ParrySign/AnimationPlayer2
onready var suicideSign = $Props/DeathSign
onready var shooters = $Props/Shooters

onready var snowRemoteTransform = $Player/ParticleRmtTrsfm

func _ready() -> void:
	GameManager.inGUI = false
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	yield(TempTimer.idle_frame(self), "timeout")
	inventory.remove_item(0)
	
	parrySign.connect("dialog_finished", parrySignAnim, "play", ["Disappear"])


func _on_load_area() -> void:
	GameManager.emit_signal("screenshake", 10, 4, .025, .333)
	if is_instance_valid(snowRemoteTransform): snowRemoteTransform.queue_free()
	
	yield(get_tree().create_timer(1.5), "timeout")
	suicideSign.dialog.start_dialog("Jumped")
	suicideSign.connect("dialog_finished", self, "start_load")


func start_load() -> void:
	yield(get_tree().create_timer(.5), "timeout")
	$ScreenTransition.out()
	var timer = Timer.new()
	
	timer.connect("timeout", self, "load_world")
	add_child(timer)
	timer.start(.3)


func load_world():
	randomize()
	var _discard = get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")


func lock_player(area: Area2D) -> void:
	if area.is_in_group("player"):
		$Tiles/Blocking/AnimationPlayer.play("Block")
		for i in shooters.get_children():
			i.start()
