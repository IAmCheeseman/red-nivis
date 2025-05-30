extends Reference
class_name Resetter


static func reset() -> void: 
	var playerData = preload("res://Entities/Player/Player.tres")
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	var worldData = GameManager.worldData
	var tradingPostData = preload("res://Entities/NPC/Birb/TradingPostData.tres")
	
	playerData.isDead = false
	playerData.maxHealth = 100
	playerData.health = playerData.maxHealth
	playerData.speedMod = 1
	playerData.damageMod = 1
	playerData.bombDmgMod = 1
	playerData.healMod = 1
	playerData.score = 0
	playerData.time = 0
	playerData.kills = 0
	playerData.immune = false
	playerData.upgrades.clear()
	playerData.passives.clear()
	
	inventory.setup()
	inventory.selectedSlot = 0
	
	worldData.rooms.clear()
	worldData.playerPos = Vector2(160, 32)
	worldData.savePlayerPos = worldData.playerPos
	worldData.savePosition = Vector2.ZERO
	
	tradingPostData.tradedWeapons.clear()
	
	FastTravel.discoveredStations.clear()
	GameManager.pickedUpItems.clear()
	
	Engine.time_scale = 1
