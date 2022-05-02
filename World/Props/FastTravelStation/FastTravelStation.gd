extends Node2D

onready var fastTravelMenu = $CanvasLayer/TeleportMenu
onready var teleportEffect = $Teleport/AnimationPlayer

onready var playerData = preload("res://Entities/Player/Player.tres")

var disableQuit = false

func _ready() -> void:
	# Adding the station to a list of stations if 
	# it's not already added.
	if FastTravel.teleportedIn:
		yield(TempTimer.idle_frame(self), "timeout")
		playerData.playerObject.lockMovement = true
		playerData.playerObject.hide()
		teleportEffect.get_parent().global_position.x\
			= playerData.playerObject.global_position.x
		FastTravel.teleportedIn = false
		GameManager.currentCamera.zoom = Vector2.ONE*.8
		GameManager.currentCamera.zoom_in(
			.8, 0, .05,
			playerData.playerObject.global_position-Vector2(0, 16)
		)
		teleportEffect.play("Spawn")
		
	if !GameManager.worldData.position\
		in FastTravel.discoveredStations:
		FastTravel.discoveredStations.append(GameManager.worldData.position)
	
	GameManager.worldData.savePosition = GameManager.worldData.position
	GameManager.worldData.savePlayerPos = global_position - Vector2(0, 8)


# Showing the teleportation gooey
func _on_interaction() -> void:
	fastTravelMenu.show()
	GameManager.inGUI = true
	disableQuit = true

# Gets called when the teleportation animation is done
func teleport() -> void:
	GameManager.inGUI = false
	FastTravel.teleportedIn = true
	var _discard = get_tree().reload_current_scene()

func spawn() -> void:
	playerData.playerObject.lockMovement = false
	playerData.playerObject.show()

# Locking the player in place and playing teleportation
# animation when a location is selected
func _on_room_selected() -> void:
	playerData.playerObject.hide()
	playerData.playerObject.lockMovement = true
	teleportEffect.get_parent().global_position.x\
	= playerData.playerObject.global_position.x
	GameManager.worldData.playerPos = playerData.playerObject.global_position
	teleportEffect.play("Teleport")
	fastTravelMenu.hide()


func _input(event: InputEvent) -> void:
	if !GameManager.inGUI or !fastTravelMenu.visible: return
	
	if disableQuit:
		disableQuit = false
		return
	for i in ["ui_cancel", "map", "interact"]:
		if event.is_action_pressed(i):
			fastTravelMenu.hide()
			yield(TempTimer.idle_frame(self),"timeout")
			GameManager.inGUI = false
