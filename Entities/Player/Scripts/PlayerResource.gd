extends Resource
class_name Player

# Stats
export var maxHealth: int = 3
export var maxAmmo: int = 10
export var magazineSize: int = 255
export var attackSpeed: float = 1.0

# Movement
export var speedMod: float = 1.0
export var maxSpeed:float = 90
export var maxAirSpeed:float = 180
export var dashSpeed:float = 320
export var accelaration:float = 5.0
export var airAccel: float
export var downGravMod := 1.4
export var jumpForce:int = 180
export var bunnyHopMult:float = 2.5
export var friction:float = 3.0
export var kbStrength:int = 45
export var maxDashes:int = 1
export var recoveryTime:float = 2.0
export var tiltStrength:float = 5.0
export var healTime := 2.0
export var healMod := 1.0

var damageMod := 1.0
var currentMod: Node2D
var healModMin := .5
var kbMod := 1.0
var bombDmgMod := 1.0

var bombType := 0

var frictMod := 1.0
var minFrict := .05
var accelMod := 1.0
var minAccel := .6

var health:int
var money := 0 setget set_money
var ammo:int setget set_ammo
var healMaterial := 0 setget set_heal_mat
var dashesLeft := 1

var unlockedEntries := [
	"res://Entities/Enemies/MiniDeathMachine/BestiaryEntry.tres",
	"res://Entities/Enemies/MiniHank/BestiaryEntry.tres",
	"res://Entities/Enemies/Bandit/Bomber/BestiaryEntry.tres",
	"res://Entities/Enemies/Gnomes/GnomeWizard/BestiaryEntry.tres",
	"res://Entities/Enemies/MinigunMachine/BestiaryEntry.tres",
]

var score := 0
var highScore := 0
var time := 0.0
var kills := 0

var godmode := false
var isReloading := false

var upgradeSlots = 2
var upgrades := []
var unlockedUpgrades := []

var passives := [
#	{
#		"item": "res://Items/Passives/FloatingRock/FloatingRock.tres",
#		"used": false
#	}
]

var immune := false

var tutorialEnabled := true

var playerObject: KinematicBody2D

var isDead := false
var isDashing := false

var deaths := 0

signal healthChanged
signal ammoChanged
signal moneyChanged
signal healMaterialChanged
signal updateHealthUI
# warning-ignore:unused_signal
signal updateGrenade
# warning-ignore:unused_signal
signal updateAbilities


func _init() -> void:
	health = 100

func _on_damage_taken(damage: int, kbDir: Vector2) -> void:
	if playerObject.state == playerObject.states.DASH or immune:
		return
	health -= int(damage)
	if Settings.doubleDamageMode: health -= int(damage)
	health = int(clamp(health, 0, maxHealth))
	emit_signal("healthChanged", kbDir)

func heal(h: int) -> void:
	health += h
	health = int(clamp(health, 0, maxHealth))
	playerObject.healVignette.modulate.a = 1
	GameManager.emit_signal(
		"screenshake",
		2, 2, .0333, .1
	)
	emit_signal("updateHealthUI")

func set_money(val):
	money = val
	emit_signal("moneyChanged")

func set_ammo(value:int) -> void:
	ammo = clamp(value, 0, maxAmmo)
	emit_signal("ammoChanged")

func set_heal_mat(value:int) -> void:
	healMaterial = int(clamp(value, 0, 100))
	emit_signal("healMaterialChanged")


