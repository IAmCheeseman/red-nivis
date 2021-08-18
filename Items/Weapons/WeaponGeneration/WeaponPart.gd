extends Node2D

# Important Info
export(
	int,
	"Common",
	"Uncommon",
	"Rare"
) var rarity = .5

# Functionality
export var damage:float = 6.0
export var accuracy:float = 0.0
export var cooldown:float = 0.2
export var multishot:float = 1
export var spread = 0.0
export var projSpeed = 340
export var projScale = 1.0
export var projLifetime = 5.0
export var peircing = false
export var recoil = 0.3
export var look : int
export var cost = 1
export var maxHoldShots = -1
export var customBullet:PackedScene

# Visual
export var bulletSprite = preload("res://Items/Weapons/Bullet/Sprites/Bullet2.png")
export var kickUp = 25
export var bulletSpawnDist = 16

export var ssFreq = .05
export var ssStrength = 7
export var isTwoHanded = false
