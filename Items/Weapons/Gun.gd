extends Node2D

export(int, "pistol", "shotgun", "rifle") var gunType = 0

# warning-ignore:unused_signal
signal onShoot

# Functionality
# Functionality
export var damage: float = 6.0
export var accuracy: float = 0.0
export var cooldown: float = 0.2
export var reloadSpeed: float = 1
export var meleeSpeed: float = .3
export var multishot: float = 1
export var spread: float = 0.0
export var projSpeed: int = 340
export var projScale: float = 1.0
export var projLifetime: float = .5
export var peircing: bool = false
export var recoil: float = 30
export var look: int
export var cost: int = 1
export var maxHoldShots: int = -1
export var customBullet: PackedScene
export var magazineSize: int = 5
export(Array, Resource) var perks: Array = []
export var burst: bool = false
export var reloadAmount: int = -1

# Visual
export var bulletSprite:StreamTexture = preload("res://Items/Weapons/Bullet/Sprites/Bullet2.png")
export var shellSprite:StreamTexture = preload("res://Items/Weapons/Bullet/Shells/shellPistol.png")
export var kickUp:float = 25
export var bulletSpawnDist:float = 16

export var ssFreq:float = .025
export var ssStrength:float = 2
export var isTwoHanded:bool = false

# Nodes
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var shootSound = $ShootSound
onready var noAmmoClick = $NoAmmoClickSFX
onready var cooldownTimer = $Cooldown
onready var meleeCooldown = $MeleeCooldown
onready var visuals = $Pivot/GunSprite

# Properties
var standingOver := false
var canShoot := false
var canSwing := true
var isReloading := false
var player: Resource



func _ready():
	player.ammo = 0
	cooldownTimer.start(reloadSpeed)
	isReloading = true
	
	meleeCooldown.wait_time = meleeSpeed
	for perk in perks:
		var perkNode = Node.new()
		perkNode.set_script(perk)
		perkNode.gun = gunLogic
		add_child(perkNode)


func _on_Cooldown_timeout():
	canShoot = true
	if isReloading:
		isReloading = false
		if reloadAmount == -1:
			player.ammo = player.maxAmmo
		else:
			if player.ammo >= player.maxAmmo:
				return
			noAmmoClick.play()
			player.ammo += reloadAmount
			isReloading = true
			cooldownTimer.start(reloadSpeed)


func _on_melee_timeout() -> void:
	canSwing = true
