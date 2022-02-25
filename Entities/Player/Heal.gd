extends TextureProgress

var playerData = preload("res://Entities/Player/Player.tres")

var finished = false

func _ready() -> void:
	playerData.connect("healthChanged", self, "_on_health_changed")
	max_value = playerData.healTime
	hide()


func _process(delta: float) -> void:
	if Input.is_action_pressed("heal")\
	and !finished\
	and playerData.healMaterial >= 100\
	and playerData.playerObject.is_grounded()\
	and playerData.health < playerData.maxHealth:
		show()
		playerData.playerObject.lockMovement = true
		value += delta
		if !GameManager.currentCamera.zoomingIn: 
			GameManager.currentCamera.zoom = lerp(
				GameManager.currentCamera.zoom, Vector2(.9, .9), delta)
		if value == max_value:
			playerData.heal(1)
			finished = true
			playerData.healMaterial = 0
			finish()
			if Input.is_action_pressed("heal"):
				finished = false


func _input(event: InputEvent) -> void:
	if event.is_action_released("heal"):
		finished = false
		finish()


func _on_health_changed(_dir: Vector2) -> void:
	finish()


func finish() -> void:
	value = 0
	playerData.playerObject.lockMovement = false
	hide()
	if !GameManager.currentCamera.zoomingIn: 
		GameManager.currentCamera.zoom = Vector2.ONE
