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
onready var sprite = $Pivot/GunSprite

# Properties
var standingOver = false
var canShoot = true
var player
var _seed = randi()


func _ready():
	sprite.self_modulate.a = 0
	var gunGenerator = WeaponConstructor.new()
	var newStats = gunGenerator.generate_weapon(_seed)
	stats = newStats
	sprite.add_child(stats.scene)
	stats.scene.position.x = stats.scene.get_node("Sprite").texture.get_width()*.3
	ammoLabel.hide()


#func _process(_delta):
#	ammoLabel.rect_global_position = sprite.global_position
#	ammoLabel.rect_position.y -= sprite.texture.get_height()
#	ammoLabel.rect_position.x -= sprite.texture.get_width()/2


func _on_Cooldown_timeout():
	canShoot = true

