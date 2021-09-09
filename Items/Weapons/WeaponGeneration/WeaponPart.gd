extends Node2D

# Important Info
export(
	int,
	"Common",
	"Uncommon",
	"Rare"
) var rarity = .5

# Functionality
export var damage: float = 6.0
export var accuracy: float = 0.0
export var cooldown: float = 0.2
export var multishot: float = 1
export var spread: float = 0.0
export var projSpeed: int = 340
export var projScale: float = 1.0
export var projLifetime: float = 5.0
export var peircing: bool = false
export var recoil: float = 0.3
export var look: int
export var cost: int = 1
export var maxHoldShots: int = -1
export var customBullet: PackedScene
export var magazineSize: int = 0
export var reloadSpeed: float = 1

# Visual
export var bulletSprite:StreamTexture = preload("res://Items/Weapons/Bullet/Sprites/Bullet2.png")
export var shellSprite:StreamTexture = preload("res://Items/Weapons/Bullet/Shells/shellPistol.png")
export var kickUp:float = 25
export var bulletSpawnDist:float = 16

export var ssFreq:float = .05
export var ssStrength:float = 7
export var isTwoHanded:bool = false
