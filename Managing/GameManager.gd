extends Node2D

var planet = 0

var isDead = false
var heldItem
var heldItemStats
var backItem
var backItemStats

var weaponStats = [null, null]

var attackingEnemies = 0 setget set_attacking_enemies


# warning-ignore:unused_signal
signal screenshake


func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"): OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("spawnGun"):
		var gun = load("res://Items/Weapons/Gun.tscn").instance()
		gun.global_position = get_global_mouse_position()
		add_child(gun)
	if Input.is_key_pressed(KEY_R):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()



func load_scene(loadPath):
	yield(get_tree(), "idle_frame")
# warning-ignore:return_value_discarded
	get_tree().change_scene(loadPath)


func set_attacking_enemies(value:int):
	attackingEnemies = value
	attackingEnemies = clamp(attackingEnemies, 0, 1)


func percentage_of(a, b) -> float:
	if a == 0 or b == 0:
		return 0.0
	return (a/b)*100


func percentage_from(percent, a) -> float:
	if percent == 0 or a == 0:
		return 0.0
	var tinyPercent = 100/percent
	return a/tinyPercent


onready var root = get_tree().root
onready var base_size = root.get_visible_rect().size


func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "_on_screen_resized")

	root.set_attach_to_screen_rect(root.get_visible_rect())
	_on_screen_resized()


func _on_screen_resized():
	if Settings.pixelPerfect:
		var new_window_size = OS.window_size

		var scale_w = max(int(new_window_size.x / base_size.x), 1)
		var scale_h = max(int(new_window_size.y / base_size.y), 1)
		var scale = min(scale_w, scale_h)

		var diff = new_window_size - (base_size * scale)
		var diffhalf = (diff * 0.5).floor()

		root.set_attach_to_screen_rect(Rect2(diffhalf, base_size * scale))

		# Black bars to prevent flickering:
		var odd_offset = Vector2(int(new_window_size.x) % 2, int(new_window_size.y) % 2)

	# warning-ignore:narrowing_conversion
	# warning-ignore:narrowing_conversion
		VisualServer.black_bars_set_margins(
			max(diffhalf.x, 0), # prevent negative values, they make the black bars go in the wrong direction.
			max(diffhalf.y, 0),
			max(diffhalf.x, 0) + odd_offset.x,
			max(diffhalf.y, 0) + odd_offset.y
		)
