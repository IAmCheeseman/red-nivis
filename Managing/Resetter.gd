extends Reference
class_name Resetter


static func reset() -> void: 
	var playerData = preload("res://Entities/Player/Player.tres")
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	var worldData = preload("res://World/WorldManagement/WorldData.tres")
	
	playerData.isDead = false
	playerData.maxHealth = 5
	playerData.health = playerData.maxHealth
	playerData.maxStamina = 3
	playerData.money = 0
	playerData.upgrades.clear()
	
	inventory.setup()
	
	worldData.rooms.clear()
	
	FastTravel.discoveredStations.clear()
	
	Engine.time_scale = 1
