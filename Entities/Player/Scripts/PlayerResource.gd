extends Resource
class_name Player

# Stats
export var maxHealth:int = 5
export var maxAmmo:int = 255

# Movement
export var maxSpeed:float = 90
export var jumpSpeedMod:float = .2
export var dashSpeed:float = 320
export var accelaration:float = 5.0
export var jumpForce:int = 180
export var bunnyHopMult:float = 2.5
export var gravity:float = 6.0
export var friction:float = 3.0
export var kbStrength:int = 45
export var maxDashes:int = 1
export var recoveryTime:float = 2.0
export var maxStamina := 5
export var staminaRecovery := 2.4
export var stamRecovCurve: Curve
export var tiltStrength:float = 5.0

var health:int
var money := 0 setget set_money
var ammo:int setget set_ammo
var dashesLeft := 1
var godmode := false

var stamina := 3 setget set_stamina

var upgradeSlots = 2
var upgrades := []

var playerObject:KinematicBody2D

var isDead := false
var isDashing := false

signal healthChanged
signal ammoChanged
signal moneyChanged
signal stamina_changed


func _init() -> void:
	health = maxHealth-1


func _on_damage_taken(damage, kbDir) -> void:
	if isDashing:
		return
	health -= damage
	emit_signal("healthChanged", kbDir)


func set_money(val):
	money = val
	emit_signal("moneyChanged")


func set_ammo(value:int) -> void:
	ammo = value
	emit_signal("ammoChanged")


func set_stamina(val:int) -> void:
	stamina = val
	emit_signal("stamina_changed")


