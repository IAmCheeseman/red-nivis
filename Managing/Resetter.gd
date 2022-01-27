extends Reference
class_name Resetter


static func reset() -> void: 
	var playerData = preload("res://Entities/Player/Player.tres")
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	var worldData = preload("res://World/WorldManagement/WorldData.tres")
	
	playerData.isDead = false
	playerData.maxHealth = 3
	playerData.health = playerData.maxHealth
	playerData.maxStamina = 3
	playerData.maxHeals = 3
	playerData.healsLeft = 3
	playerData.money = 0
	playerData.score = 0
	playerData.time = 0
	playerData.kills = 0
	playerData.upgrades.clear()
	
	inventory.setup()
	
	worldData.rooms.clear()
	worldData.playerPos = Vector2(160, 32)
	worldData.savePlayerPos = worldData.playerPos
	worldData.savePosition = Vector2.ZERO
	
	FastTravel.discoveredStations.clear()
	GameManager.pickedUpItems.clear()
	
	Engine.time_scale = 1
