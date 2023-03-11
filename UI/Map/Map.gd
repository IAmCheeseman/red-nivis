extends ViewportContainer


onready var tiles:TileMap = $Viewport/MapTiles
onready var camera:Camera2D = $Viewport/Camera
onready var player:Sprite = $Viewport/Player
onready var viewport:Viewport = $Viewport
onready var blur = $Node2D/Blur
onready var selection = $Selection
onready var mapGenerator = $MapGenerator
onready var prompts = $"../../Prompts"

var mapData = preload("res://World/WorldManagement/WorldData.tres")

var miniPosition:Vector2
var miniSize:Vector2
var playerTarget: Vector2


func _ready() -> void:
	hide()
	prompts.hide()
	
	yield(TempTimer.idle_frame(self), "timeout")
	miniPosition = rect_position
	miniSize = rect_size
	
	mapGenerator.generate_map()
	
	camera.position = mapData.position * tiles.cell_size + tiles.cell_size * 0.5
	camera.position = camera.position.round()
	player.position = camera.position
	playerTarget = camera.position
	camera.position = player.position

func _process(_delta: float) -> void:
	blur.rect_size = get_viewport_rect().end

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		if !visible and GameManager.inGUI:
			return
		visible = not visible
		prompts.visible = not prompts.visible
		GameManager.inGUI = visible
	
	if event is InputEventMouseMotion\
	and Input.is_action_pressed("use_item")\
	and visible:
		camera.position -= event.relative
		return
