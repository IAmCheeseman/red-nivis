extends Node2D

onready var blockCollision = $Decoration/DoorBlock/CollisionShape2D
onready var block = $Decoration/DoorBlock


var inventory = preload("res://UI/Inventory/Inventory.tres")
var player = preload("res://Entities/Player/Player.tres")

var prevInventory: Array
var prevAbilities: Array
var prevHealth: int
var prevStamina: int


func _ready() -> void:
	prevInventory = inventory.items.duplicate(true)
	prevAbilities = player.upgrades.duplicate()
	prevHealth = player.health
	prevStamina = player.stamina
	
	player.health = 4
	player.stamina = 3
	inventory.clear()
	yield(TempTimer.idle_frame(self), "timeout")
	inventory.add_item("pump-shotgun")
	inventory.add_item("flamethrower")

func _on_boss_arena_cam_focused() -> void:
	block.show()
	blockCollision.disabled = false
