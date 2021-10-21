extends ViewportContainer


onready var tiles:TileMap = $Viewport/MapTiles
onready var camera:Camera2D = $Viewport/Camera
onready var player:Sprite = $Viewport/Player
onready var viewport:Viewport = $Viewport

var mapData = preload("res://World/WorldManagement/WorldData.tres")
var minimapAlphaBorder = preload("res://UI/Assets/MapAlpha.png")
var mapAlphaBorder = preload("res://UI/Assets/MapAlphaLarge.png")

var inMiniMode := true
var miniPosition:Vector2
var miniSize:Vector2


func _ready() -> void:
	miniPosition = rect_position
	miniSize = rect_size
	for x in mapData.rooms.size():
		for y in mapData.rooms[0].size():
			var biome = mapData.rooms[x][y].biome
			var roomIcon = mapData.rooms[x][y].roomIcon
			if biome:
				tiles.set_cell(x, y, 0)
				if roomIcon:
					var sprite = Sprite.new()
					sprite.texture = roomIcon
					sprite.centered = false
					sprite.position = Vector2(x, y)*tiles.cell_size
					tiles.add_child(sprite)
	camera.position = mapData.position*tiles.cell_size+tiles.cell_size*.5
	player.position = camera.position
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		rect_position = Vector2.ZERO
		rect_size = get_viewport_rect().end
		viewport.size = rect_size
		tiles.material.set_shader_param("alpha", mapAlphaBorder)
		inMiniMode = false
		GameManager.inGUI = true
	
	if event.is_action_released("map"):
		rect_position = miniPosition
		rect_size = miniSize
		viewport.size = rect_size
		tiles.material.set_shader_param("alpha", minimapAlphaBorder)
		camera.position = mapData.position*tiles.cell_size+tiles.cell_size*.5
		inMiniMode = true
		GameManager.inGUI = false
	
	if event is InputEventMouseMotion\
	and Input.is_action_pressed("use_item")\
	and !inMiniMode:
		camera.position -= event.relative
