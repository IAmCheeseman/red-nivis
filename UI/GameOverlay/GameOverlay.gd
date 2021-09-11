extends Control

var playerData = preload("res://Player/Player.tres")

# Health Bar
onready var healthBar = $HealthBar
onready var healthBarEmpty = $HealthBar/Empty
onready var hbAnim = $HealthBar/AnimationPlayer
onready var hbShakeAnim = $HealthBar/ShakeAnim
onready var hpLabel = $HPLabel

onready var justLostBar = $HealthBar/JustLost
onready var justLostTween = $HealthBar/JustLost/JustLostTween
onready var justLostTimer = $HealthBar/JustLost/JustLostTimer

# Ammo bar
onready var ammoBar = $AmmoBar
onready var ammoLabel = $AmmoLabel

var JLTarget:Vector2
var healthBarTexSize:Vector2
var ammoBarTexSize:Vector2


func _ready() -> void:
	healthBarTexSize = healthBar.texture.get_size()
#	ammoBarTexSize = ammoBar.texture.get_size()
	
	playerData.connect("healthChanged", self, "update_health")
	playerData.connect("ammoChanged", self, "update_ammo")
	
	update_health(Vector2.ZERO)
	update_ammo()


func update_health(_kb:Vector2) -> void:
	healthBar.rect_size.x = playerData.health*healthBarTexSize.x
	healthBarEmpty.rect_size.x = playerData.maxHealth*healthBarTexSize.x
	hpLabel.text = "HP: %s/%s" % [playerData.health, playerData.maxHealth]
	
	hbAnim.play("Flash")
	justLostTimer.start()
	if playerData.health == 1:
		hbShakeAnim.play("Shake")
	else:
		hbShakeAnim.stop(true)


func update_ammo():
	if ammoBar.get_child_count() != playerData.maxAmmo:
		Utils.free_children(ammoBar)

		var ammoPoint = preload("res://UI/GameOverlay/AmmoPoint.tscn")
		for i in playerData.maxAmmo:
			var newAmmoPoint = ammoPoint.instance()
			ammoBar.add_child(newAmmoPoint)
	else:
		ammoLabel.text = "Ammo: %s/%s" % [playerData.ammo, playerData.maxAmmo]
		if playerData.ammo == 0: ammoLabel.text = "Reloading..."
		for i in ammoBar.get_children():
			if i.get_index()+1 > playerData.ammo:
				i.self_modulate.a = 0
			else:
				i.self_modulate.a = 1



func _on_just_lost_timer_timeout() -> void:
	justLostTween.stop_all()
	justLostTween.interpolate_property(
		justLostBar, "rect_size", justLostBar.rect_size,
		healthBar.rect_size, .2
	)
	justLostTween.start()

