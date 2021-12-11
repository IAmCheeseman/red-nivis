extends ViewportContainer


onready var tiles:TileMap = $Viewport/MapTiles
onready var camera:Camera2D = $Viewport/Camera
onready var player:Sprite = $Viewport/Player
onready var viewport:Viewport = $Viewport
onready var blur = $Node2D/Blur

# TODO: Make a teleport mode where you can teleport to stations.

var mapData = preload("res://World/WorldManagement/WorldData.tres")

var inMiniMode := true
var miniPosition:Vector2
var miniSize:Vector2


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	miniPosition = rect_position
	miniSize = rect_size
	for x in mapData.rooms.size():
		for y in mapData.rooms[0].size():
			var biome = mapData.rooms[x][y].biome
			var roomIcon = mapData.rooms[x][y].roomIcon
			if biome:
				tiles.set_cell(x, y, 0)
				if mapData.rooms[x][y].discovered or GameManager.revealMap:
					tiles.set_cell(x, y, biome.biomeIndex+1)
					set_icon(roomIcon, x, y)
				elif mapData.rooms[x][y].nearDiscovered or mapData.rooms[x][y].typeAlwaysVisible:
					set_icon(roomIcon, x, y)
					
	camera.position = mapData.position*tiles.cell_size+tiles.cell_size*.5
	camera.position = camera.position.round()
	player.position = camera.position


func set_icon(roomIcon, x, y):
	if roomIcon:
		var sprite = Sprite.new()
		sprite.texture = roomIcon
		sprite.centered = false
		sprite.position = Vector2(x, y)*tiles.cell_size
		tiles.add_child(sprite)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		rect_position = Vector2.ZERO
		rect_size = get_viewport_rect().end
		viewport.size = rect_size
		blur.show()
		inMiniMode = false
		GameManager.inGUI = true
		tiles.material.set_shader_param("isOn", false)
	
	if event.is_action_released("map"):
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
