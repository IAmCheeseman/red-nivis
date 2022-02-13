extends Node2D

onready var blockCollision = $Decoration/DoorBlock/CollisionShape2D
onready var block = $Decoration/DoorBlock
onready var bg = $CanvasLayer/BG
onready var darkness = $Darkness


var inventory = preload("res://UI/Inventory/Inventory.tres")
var player = preload("res://Entities/Player/Player.tres")

var prevInventory: Array
var prevAbilities: Array
var prevHealth: int
var prevMaxHp: int
var prevStamina: int


func _ready() -> void:
	# Visual
	var caves = preload("res://World/Biomes/Caves.tres")
	bg.color = caves.bgColor
	darkness.color = Color(caves.brightness, caves.brightness, caves.brightness, 1)
	
	# Player config
	prevInventory = inventory.items.duplicate(true)
	prevAbilities = player.upgrades.duplicate()
	prevHealth = player.health
	prevMaxHp = player.maxHealth
	prevStamina = player.stamina
	
	player.upgrades.append("res://Items/Upgrades/Teleport/Teleport.tres")
	player.health = 4
	player.maxHealth = 4
	player.stamina = 3
	player.emit_signal("healthChanged", Vector2.ZERO)
	player.emit_signal("updateAbilities")
	
	inventory.clear()
	yield(TempTimer.idle_frame(self), "timeout")
	inventory.add_item("pump-shotgun")
	inventory.add_item("flamethrower")
	inventory.selectedSlot += 1
	yield(TempTimer.idle_frame(self), "timeout")
	inventory.selectedSlot -= 1


func _on_boss_arena_cam_focused() -> void:
	block.show()
	blockCollision.set_deferred("disabled", false)


func _exit_tree() -> void:
	# Resetting the player
	player.maxHealth = prevMaxHp
	player.health = prevHealth
	player.stamina = prevStamina
	player.upgrades = prevAbilities
	inventory.items = prevInventory


func _on_HANK_dead() -> void:
	yield(TempTimer.timer(self, 1), "timeout")
	var _discard = get_tree().change_scene("res://World/WorldManagement/World.tscn")
