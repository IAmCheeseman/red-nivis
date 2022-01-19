extends Control

var playerData = preload("res://Entities/Player/Player.tres")
var inventory = preload("res://UI/Inventory/Inventory.tres")

# Health Bar
onready var healthBar = $VBox/HealthBar
onready var healthBarEmpty = $VBox/HealthBar/Empty
onready var hbAnim = $VBox/HealthBar/AnimationPlayer
onready var hbShakeAnim = $VBox/HealthBar/ShakeAnim

onready var justLostBar = $VBox/HealthBar/JustLost
onready var justLostTween = $VBox/HealthBar/JustLost/JustLostTween
onready var justLostTimer = $VBox/HealthBar/JustLost/JustLostTimer

# Ammo bar
#onready var ammoBar = $VBox/Bottom/AmmoBar/Icons
onready var ammoBar = $VBox/Bottom/AmmoBar/TextureProgress
onready var reloadNotif = $VBox/Bottom/AmmoBar/ReloadNotif
onready var ammoTween = $VBox/Bottom/AmmoBar/Tween

onready var healsBar = $VBox/Bottom/HealsAndBomb/Heals/Icons

# Money Counter
onready var moneyLabel = $VBox/Bottom/MoneyDisplay/Label

onready var grenade = $VBox/Bottom/BombProgressBar

onready var time = $Time

var JLTarget:Vector2
var healthBarTexSize:Vector2
var ammoBarTexSize:Vector2


func _ready() -> void:
	healthBarTexSize = healthBar.texture.get_size()
#	ammoBarTexSize = ammoBar.texture.get_size()
	
	playerData.connect("healthChanged", self, "update_health")
	playerData.connect("ammoChanged", self, "update_ammo")
	playerData.connect("healsChanged", self, "update_heals")
	playerData.connect("moneyChanged", self, "update_money")
	playerData.connect("updateGrenade", self, "update_grenade")
	inventory.connect("itemAdded", self, "_on_item_picked_up")
	
	update_health(Vector2.ZERO)
	update_ammo()
	update_heals()
	update_money()
	
	yield(TempTimer.idle_frame(self, 2), "timeout")
	if inventory.is_empty(): hide()


func _process(_delta: float) -> void:
	reloadNotif.hide()
	if playerData.isReloading:
		reloadNotif.show()
		reloadNotif.text = "..."
	
	if Settings.speedrunTimer:
		var seconds = str(int(playerData.time) % 60)
		if seconds.length() == 1: seconds = "0"+seconds
		var minutes = str(int(playerData.time) % int(3600 / 60))
		time.text = "Time\n%s:%s" % [minutes, seconds]
	else:
		time.text = ""


func update_health(_kb:Vector2) -> void:
	healthBar.rect_min_size.x = (playerData.health*healthBarTexSize.x)
	healthBarEmpty.rect_size.x = playerData.maxHealth*healthBarTexSize.x
	
	hbAnim.play("Flash")
	justLostTimer.start()
	if playerData.health == 1:
		hbShakeAnim.play("Shake")
	else:
		hbShakeAnim.stop(true)


func update_money() -> void:
	moneyLabel.text = "%s" % playerData.money


func update_grenade(val: float, enabled: bool) -> void:
	grenade.visible = enabled 
	grenade.value = grenade.max_value - val
	if grenade.value != grenade.max_value:
		grenade.modulate = Color.darkgray
		return
	grenade.modulate = Color.white


func update_ammo() -> void:
	#ammoBar.value = float(playerData.ammo) / float(playerData.maxAmmo)
	ammoTween.interpolate_property(
		ammoBar, "value",
		ammoBar.value, float(playerData.ammo) / float(playerData.maxAmmo),
		.05
	)
	ammoTween.start()

func update_heals() -> void:
	if healsBar.get_child_count() != playerData.maxHeals:
		Utils.free_children(healsBar)
		
		var healPoint = preload("res://UI/GameOverlay/Heal.tscn")
		for i in playerData.maxHeals:
			var newHealPoint = healPoint.instance()
			healsBar.add_child(newHealPoint)
			if newHealPoint.get_index()+1 > playerData.healsLeft:
				newHealPoint.self_modulate.a = 0
			else:
				newHealPoint.self_modulate.a = 1
	else:
		for i in healsBar.get_children():
			if i.get_index()+1 > playerData.healsLeft:
				i.self_modulate.a = 0
			else:
				i.self_modulate.a = 1
	update_health(Vector2.ZERO)


func _on_just_lost_timer_timeout() -> void:
	justLostTween.stop_all()
	justLostTween.interpolate_property(
		justLostBar, "rect_size", justLostBar.rect_size,
		healthBar.rect_size, .2
	)
	justLostTween.start()

func _on_item_picked_up(_id) -> void: show()
