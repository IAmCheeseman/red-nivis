extends Node2D

export(int, "pistol", "shotgun", "rifle", "bow") var gunType = 0

# warning-ignore:unused_signal
signal onShoot

# Functionality
export var damage: float = 6.0
export var meleeDamageOverride: float = -1.0
export var accuracy: float = 0.0
export var cooldown: float = 0.2
export var reloadSpeed: float = 1
export var meleeSpeed: float = .75
export var multishot: float = 1
export var spread: float = 0.0
export var projSpeed: int = 340 * 2
export var projSpeedRange := Vector2(-50, 60)
export var projScale: Vector2 = Vector2(1, 1)
export var projLifetime: float = .5
export var projKB: float = 3
export var peircing: bool = false
export var recoil: float = 120
export var look: int
export var cost: int = 1
export var maxHoldShots: int = -1
export var customBullet: PackedScene
export var magazineSize: int = 5
export(Script) var perk
export var burst: bool = false
export var reloadAmount: int = -1

# Visual
export var reloadSprite:StreamTexture
export var bulletSprite:StreamTexture = preload("res://Items/Weapons/Bullet/Sprites/Bullet2.png")
export var shellSprite:StreamTexture = preload("res://Items/Weapons/Bullet/Shells/shellPistol.png")
export var cursor: AtlasTexture = preload("res://UI/Cursor/CursorNormal.tres")
export var kickUp:float = 25
export var bulletSpawnDist:float = 16

export var ssFreq:float = .025
export var ssStrength:float = 2
export var isTwoHanded:bool = false

export var reloadAngle = -1

# Nodes
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var shootSound = $ShootSound
onready var noAmmoClick = $NoAmmoClickSFX
onready var cooldownTimer = $Cooldown
onready var meleeCooldown = $MeleeCooldown
onready var visuals = $Pivot/GunSprite
onready var gunPos = visuals.position
onready var ogSprite = visuals.texture

# Properties
var standingOver := false
var canShoot := false
var canSwing := true
var invenIdx = 0
var player: Resource
var inventory = preload("res://UI/Inventory/Inventory.tres")


func _ready():
	yield(TempTimer.idle_frame(self), "timeout")
	player.ammo = inventory.items[invenIdx].ammoLeft
	if player.ammo == -1:
		player.ammo = magazineSize
	
	canShoot = true
	
	Cursor.get_node("Sprite").texture = cursor

	meleeCooldown.wait_time = meleeSpeed


func _process(_delta: float) -> void:
	visuals.texture = ogSprite


func _on_Cooldown_timeout():
	canShoot = true
	inventory.items[invenIdx].ammoLeft = player.ammo


func _on_melee_timeout() -> void:
	canSwing = true

