extends ViewportContainer


onready var tiles:TileMap = $Viewport/MapTiles
onready var camera:Camera2D = $Viewport/Camera
onready var player:Sprite = $Viewport/Player
onready var viewport:Viewport = $Viewport
onready var blur = $Node2D/Blur
onready var selection = $Selection#Viewport/Selection
onready var mapGenerator = $MapGenerator

var mapData = preload("res://World/WorldManagement/WorldData.tres")

var inMiniMode := true
var miniPosition:Vector2
var miniSize:Vector2
var playerTarget: Vector2


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	miniPosition = rect_position
	miniSize = rect_size
	
	mapGenerator.generate_map()
	
	camera.position = mapData.position*tiles.cell_size+tiles.cell_size*.5
	camera.position = camera.position.round()
	player.position = camera.position - (mapData.moveDir * (tiles.cell_size * 1))
	playerTarget = camera.position
	camera.position = player.position
	
	var tween = $Tween
	tween.interpolate_property(
		player, "position",
		player.position, playerTarget,
		.7, Tween.TRANS_ELASTIC
	)
	tween.start()


func _process(_delta: float) -> void:
	if inMiniMode: camera.position = player.position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		if inMiniMode and !GameManager.inGUI:
			rect_position = Vector2.ZERO
			rect_size = get_viewport_rect().end
			viewport.size = rect_size
			blur.show()
			blur.rect_size = rect_size
			inMiniMode = false
			GameManager.inGUI = true
			tiles.material.set_shader_param("isOn", false)
		elif !inMiniMode:
			rect_position = miniPosition
			rect_size = miniSize
			viewport.size = rect_size
			blur.hide()
			camera.position = mapData.position*tiles.cell_size+tiles.cell_size*.5
			inMiniMode = true
			GameManager.inGUI = false
			tiles.material.set_shader_param("isOn", true)
	
	if event is InputEventMouseMotion\
	and Input.is_action_pressed("use_item")\
	and !inMiniMode:
		camera.position -= event.relative
		return
