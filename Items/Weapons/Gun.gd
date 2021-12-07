extends Node2D

export(int, "pistol", "shotgun") var gunType = 0

# warning-ignore:unused_signal
signal onShoot

# Functionality
# Functionality
export var damage: float = 6.0
export var accuracy: float = 0.0
export var cooldown: float = 0.2
export var reloadSpeed: float = 1
export var meleeSpeed: float = 1.2
export var multishot: float = 1
export var spread: float = 0.0
export var projSpeed: int = 340
export var projScale: float = 1.0
export var projLifetime: float = .5
export var peircing: bool = false
export var recoil: float = 0.3
export var look: int
export var cost: int = 1
export var maxHoldShots: int = -1
export var customBullet: PackedScene
export var magazineSize: int = 5
export(Array, Resource) var perks: Array = []

# Visual
export var bulletSprite:StreamTexture = preload("res://Items/Weapons/Bullet/Sprites/Bullet2.png")
export var shellSprite:StreamTexture = preload("res://Items/Weapons/Bullet/Shells/shellPistol.png")
export var kickUp:float = 25
export var bulletSpawnDist:float = 16

export var ssFreq:float = .05
export var ssStrength:float = 7
export var isTwoHanded:bool = false

# Nodes
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var shootSound = $ShootSound
onready var noAmmoClick = $NoAmmoClickSFX
onready var ammoLabel = $AmmoCount
onready var cooldownTimer = $Cooldown
onready var meleeCooldown = $MeleeCooldown
onready var visuals = $Pivot/GunSprite

# Properties
var standingOver := false
var canShoot := false
var canSwing := true
var isReloading := false
var player: Resource
#var perk: Node



func _ready():
	ammoLabel.hide()
	cooldownTimer.start(reloadSpeed*.333)
	meleeCooldown.wait_time = meleeSpeed
	
#	if perk:
#		perkNode = Node.new()
#		perkNode.set_script(perk)
#		perk.gun = gunLogic
#		add_child(perk)


func _on_Cooldown_timeout():
	canShoot = true
	if isReloading:
		isReloading = false
		player.ammo = player.maxAmmo


func _on_melee_timeout() -> void:
	canSwing = true
