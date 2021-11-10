extends HBoxContainer


var playerData = preload("res://Entities/Player/Player.tres")
var staminaFull = preload("res://UI/Assets/Stamina.png")
var staminaEmpty = preload("res://UI/Assets/StaminaEmpty.png")

var targetA = 0.0

onready var regainTimer:Timer = $RegainTimer


func _ready() -> void:
	modulate.a = 0
	var _discard0 = regainTimer.connect("timeout", self, "_on_regain_timeout")
	var _discard1 = playerData.connect("stamina_changed", self, "_on_stamina_changed")
	
	playerData.stamina = playerData.maxStamina
	update_stamina()


func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, targetA, 10*delta)


func update_stamina() -> void:
	for i in get_children():
		if !i is Timer: i.queue_free()
	for i in playerData.maxStamina:
		var newBar = TextureRect.new()
		if i >= playerData.stamina:
			newBar.texture = staminaEmpty
		else:
			newBar.texture = staminaFull
		add_child(newBar)
	if playerData.stamina != playerData.maxStamina:
		targetA = 1
	else:
		targetA = 0


func _on_stamina_changed() -> void:
	regainTimer.start()
	update_stamina()


func _on_regain_timeout() -> void:
	playerData.stamina += 1
	playerData.stamina = clamp(playerData.stamina, 0, playerData.maxStamina)
	update_stamina()
	if playerData.stamina == playerData.maxStamina:
		regainTimer.stop()
