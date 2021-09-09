extends Control

var playerData = preload("res://Player/Player.tres")

# Health Bar
onready var healthBar = $HealthBar
onready var healthBarEmpty = $HealthBar/Empty
onready var hbAnim = $HealthBar/AnimationPlayer
onready var hbShakeAnim = $HealthBar/ShakeAnim
onready var hpLabel = $HealthBar/HPLabel

# Ammo bar
onready var ammoBar = $AmmoBar
onready var ammoBarEmpty = $AmmoBar/Empty


var healthBarTexSize:Vector2
var ammoBarTexSize:Vector2


func _ready() -> void:
	healthBarTexSize = healthBar.texture.get_size()
	ammoBarTexSize = ammoBar.texture.get_size()
	
	playerData.connect("healthChanged", self, "update_health")
	playerData.connect("ammoChanged", self, "update_ammo")
	
	update_health(Vector2.ZERO)


func update_health(_kb:Vector2) -> void:
	healthBar.rect_size.x = playerData.health*healthBarTexSize.x
	healthBarEmpty.rect_size.x = playerData.maxHealth*healthBarTexSize.x
	hpLabel.text = "HP: %s/%s" % [playerData.health, playerData.maxHealth]
	
	hbAnim.play("Flash")
	if playerData.health == 1:
		hbShakeAnim.play("Shake")
	elif playerData.health <= 0:
		healthBar.rect_size.x = 0
	else:
		hbShakeAnim.stop(true)


func update_ammo():
	ammoBar.rect_size.x = playerData.ammo*ammoBarTexSize.x
	ammoBarEmpty.rect_size.x = playerData.maxAmmo*ammoBarTexSize.x
