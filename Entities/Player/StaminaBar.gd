extends HBoxContainer


var playerData = preload("res://Entities/Player/Player.tres")
var staminaFull = preload("res://UI/Assets/StaminaFull.tres")
var staminaEmpty = preload("res://UI/Assets/StaminaEmpty.tres")

var targetA = 0.0
var defaultY: int

var healed := 0


func _ready() -> void:
	defaultY = int(rect_position.y)
	modulate.a = 0
	
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
	rect_position = -rect_size / 2 + Vector2(0, defaultY)

