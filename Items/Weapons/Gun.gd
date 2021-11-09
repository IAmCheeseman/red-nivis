extends Node2D

export(int, "pistol", "shotgun") var gunType = 0

# warning-ignore:unused_signal
signal onShoot

# Functionality
var stats = {
	"damage" : 6.0,
	"accuracy" : 8.0,
	"cooldown" : 0.2,
	"multishot" : 1,
	"spread" : 0.0,
	"projSpeed" : 340,
	"projScale" : 1.0,
	"projLifetime" : 5.0,
	"peircing" : false,
	"recoil" : 0.3,
	"cost" : 1.0,
	"maxHoldShots" : -1,
	"customBullet" : null,

	# Visual
	"bulletSprite" : preload("res://Items/Weapons/Bullet/Sprites/Bullet2.png"),
	"kickUp" : 25,
	"bulletSpawnDist" : 16,

	"ssFreq" : .05,
	"ssStrength" : 7,
	"isTwoHanded" : false
}

# Nodes
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var shootSound = $ShootSound
onready var noAmmoClick = $NoAmmoClickSFX
onready var ammoLabel = $AmmoCount
onready var cooldown = $Cooldown
onready var meleeCooldown = $MeleeCooldown
var visuals

# Properties
var standingOver = false
var canShoot = false
var canSwing = true
var isReloading = false
var player



func _ready():
	visuals = stats.scene.duplicate()
	pivot.add_child(visuals)
	visuals.position.x = stats.holdDist
	ammoLabel.hide()
	cooldown.start(stats.reloadSpeed*.333)
	
	meleeCooldown.wait_time = stats.reloadSpeed*.333


func _on_Cooldown_timeout():
	canShoot = true
	if isReloading:
		isReloading = false
		player.ammo = player.maxAmmo


func _on_melee_timeout() -> void:
	canSwing = true
