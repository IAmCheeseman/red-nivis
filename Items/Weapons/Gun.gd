extends Node2D

onready var pickUpArea = $PickUpArea
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var tooltips = $TooltipHolder/GunTooltips/Tooltips
onready var tooltipsAnim = $TooltipHolder/GunTooltips/AnimationPlayer
onready var tooltipHolder = $TooltipHolder
onready var shootSound = $ShootSound

var standingOver = false
var canShoot = true
var player
var isPickedUp = false

export(int, "pistol", "shotgun") var gunType = 0

# warning-ignore:unused_signal
signal onShoot

# Functionality
export var damage = 6.0
export var accuracy = 8.0
export var cooldown = 0.2
export var multishot = 1
export var spread = 0.0
export var projSpeed = 340
export var projScale = 1.0
export var projLifetime = 5.0
export var peircing = false
export var recoil = 0.3
export var look : int
export var cost = 1

# Visual
export var bulletSprite = preload("res://Items/Weapons/Bullet/Sprites/Bullet2.png")
export var lightTexture = preload("res://Items/Weapons/Bullet/Lights/bulletLight2.png")
export var kickUp = 25
export var bulletSpawnDist = 16


func _ready():
	set_logic(isPickedUp)
	if !isPickedUp:
		rotation_degrees = rand_range(0, 360)


func _on_PickUpArea_area_entered(area):
	if area.is_in_group("player"):
		standingOver = true
		player = area.get_parent()


func _on_PickUpArea_area_exited(area):
	if area.is_in_group("player"):
		standingOver = false


func _on_Cooldown_timeout():
	canShoot = true


func set_logic(on:bool):
	gunLogic.set_physics_process(on)


func equip_self():
	isPickedUp = true
	GameManager.heldItems[0] = self.duplicate()
	set_logic(true)
	pickUpArea.monitoring = false
	player.add_item(self)


func _input(event):
	if event.is_action_pressed("interact") and standingOver:
		equip_self()
