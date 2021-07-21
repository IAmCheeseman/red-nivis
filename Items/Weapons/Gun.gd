extends Node2D

export(int, "pistol", "shotgun") var gunType = 0

# warning-ignore:unused_signal
signal onShoot

# Functionality
export var damage:float = 6.0
export var accuracy:float = 8.0
export var cooldown:float = 0.2
export var multishot:int = 1
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

# Nodes
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var shootSound = $ShootSound
onready var noAmmoClick = $NoAmmoClickSFX
onready var ammoLabel = $Pivot/GunSprite/AmmoCount
onready var sprite = $Pivot/GunSprite

# Properties
var standingOver = false
var canShoot = true
var player


func _ready():
	ammoLabel.rect_position.y = -sprite.texture.get_height()
	ammoLabel.text = "%s/%s" % [player.playerData.ammo, player.playerData.maxAmmo]


func _on_Cooldown_timeout():
	canShoot = true

