extends Node2D

onready var pickUpArea = $PickUpArea
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var tooltips = $TooltipHolder/GunTooltips/Tooltips
onready var tooltipsAnim = $TooltipHolder/GunTooltips/AnimationPlayer
onready var tooltipHolder = $TooltipHolder
onready var shootSound = $ShootSound

var canShoot = true

export(int, "pistol") var gunType = 0

# Functionality
export var damage = 6.0
export var accuracy = 8.0
export var cooldown = 0.2
export var multishot = 1
export var speed = 340
export var peircing = false
export var recoil = 0.3

# Visual
export var bulletSprite : StreamTexture
export var kickUp = 25