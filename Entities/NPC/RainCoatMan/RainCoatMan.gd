extends "res://Entities/NPC/NPC.gd"

const BOMB = 2

onready var explosionSFX = $ExplosionSFX


func _add_states() -> void:
	states.append("bomb_state")


func bomb_state(_delta: float) -> void:
	pass


func _on_dialog_signal(signalName: String) -> void:
	match signalName:
		"bomb":
			state = BOMB
			anim.play("Press")


func _on_dialog_timer_done(currentDialog) -> void:
	if currentDialog == 7:
		yield(TempTimer.timer(self, 1.25), "timeout")
		QuestManager.end_quest("matthews_bomb")
		queue_free()
		return
	add_explosion()
	GameManager.emit_signal("screenshake", 10, 8, .025, .15)
	sprite.hide()


func add_explosion(size:int=32) -> void:
	var newExplosion = preload("res://Entities/Enemies/Explosion/ExplosionParticles.tscn").instance()

	newExplosion.global_position = sprite.global_position

	newExplosion.emitting = true
	newExplosion.process_material = newExplosion.process_material.duplicate()
	newExplosion.process_material.emission_sphere_radius = size
	newExplosion.z_index = 2
	GameManager.spawnManager.add_child(newExplosion)

	var timer = get_tree().create_timer(3)
	timer.connect("timeout", newExplosion, "queue_free")

	explosionSFX.play()


func _on_start_talking() -> void:
	if QuestManager.get_quest_data("matthews_bomb", "player_has_bomb"):
		defaultDialog = "Introduction"
		idleAnim = "Default_Button"
		QuestManager.set_quest_data(
			"matthews_bomb", "matthew_has_bomb",
			true
		)


func start_quest() -> void:
	if defaultDialog == "Distress":
		QuestManager.start_quest("matthews_bomb")
		return
