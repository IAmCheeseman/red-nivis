extends Node2D

var tiles:TileMap
var altTiles:Array
var backgroundTiles:TileMap
onready var player = $Props/Player
onready var backgrounds = $Background
onready var sky = $Sky/Sky
onready var camera = $Props/Player/Camera
onready var props = $Props
onready var atmosphere = $Atmosphere
onready var mistSpawner = $Props/Player/MistSpawner
onready var tilePlaceSFX = $TilePlaceSFX
onready var enemySpawner = $Props/EnemySpawner

var queuedChunks : Array
var queueFreeChunks : Array
var generatedChunks : Array
var ruinedChunks : Array
var propedChunks : Array
var lastChunk = Vector2.ZERO
var chunkAmount = 3
var firstTime = true
var enemyCount = 0


func _ready():
	pass


func _on_drop_gun(gun, pos):
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	props.add_child(gun)
