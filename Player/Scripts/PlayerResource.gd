extends Resource
class_name Player

# Stats
export var maxHealth:int = 100
export var maxAmmo:int = 255

# Movement
export var maxSpeed:float = 90
export var jumpSpeedMod:float = .2
export var accelaration:float = 5.0
export var jumpForce:int = 180
export var bunnyHopMult:float = 2.5
export var gravity:float = 6.0
export var friction:float = 3.0
export var kbStrength:int = 45
export var recoveryTime:float = 2.0
export var tiltStrength:float = 5.0

var health:int
var ammo:int setget set_ammo

var isDead = false

signal healthChanged
signal ammoChanged


func _init():
	health = maxHealth
	ammo = maxAmmo


func _on_damage_taken(damage, kbDir):
	health -= damage
	emit_signal("healthChanged", kbDir)


func set_ammo(value:int):
	ammo = value
	emit_signal("ammoChanged")



