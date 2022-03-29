extends Control

var playerData = preload("res://Entities/Player/Player.tres")
var inventory = preload("res://UI/Inventory/Inventory.tres")

# Health Bar
onready var healthBar = $VBox/Health/HealthBar
onready var healthBarEmpty = $VBox/Health/HealthBar/Empty
onready var hbAnim = $VBox/Health/HealthBar/AnimationPlayer
onready var hbShakeAnim = $VBox/Health/HealthBar/ShakeAnim

onready var justLostBar = $VBox/Health/HealthBar/JustLost
onready var justLostTween = $VBox/Health/HealthBar/JustLost/JustLostTween
onready var justLostTimer = $VBox/Health/HealthBar/JustLost/JustLostTimer

onready var healBar = $VBox/Health/HealProgress
onready var healBarTween = $VBox/Health/HealProgress/HealProgressTween

# Ammo bar
#onready var ammoBar = $VBox/Bottom/AmmoBar/Icons
onready var ammoBar = $VBox/Bottom/AmmoBar/TextureProgress
onready var reloadNotif = $VBox/Bottom/AmmoBar/ReloadNotif
onready var ammoTween = $VBox/Bottom/AmmoBar/Tween

# Money Counter
onready var moneyLabel = $VBox/Bottom/MoneyDisplay/Label

onready var grenade = $VBox/Bottom/BombProgressBar

onready var upgrades = $TopRight/Upgrades

onready var time = $TopRight/Time

var JLTarget:Vector2
var healthBarTexSize:Vector2
var ammoBarTexSize:Vector2


func _ready() -> void:
	healthBarTexSize = healthBar.texture.get_size()

	playerData.connect("healthChanged", self, "update_health")
	playerData.connect("updateHealthUI", self, "update_health", [Vector2.ZERO])
	playerData.connect("ammoChanged", self, "update_ammo")
#	playerData.connect("healsChanged", self, "update_heals")
	playerData.connect("moneyChanged", self, "update_money")
	playerData.connect("updateGrenade", self, "update_grenade")
	playerData.connect("healMaterialChanged", self, "update_heals")
	inventory.connect("itemAdded", self, "_on_item_picked_up")

	update_health(Vector2.ZERO)
	update_ammo()
	update_heals()
	update_money()
	update_abilities()

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
# warning-ignore:integer_division
		var minutes = str(int(playerData.time) % 3600 / 60)
# warning-ignore:integer_division
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
	healBarTween.stop_all()
	healBarTween.interpolate_property(
		healBar, "value",
		healBar.value, playerData.healMaterial,
		.1
	)
	healBarTween.start()
	if playerData.healMaterial >= 100:
		healBar.texture_progress =   preload("res://UI/Assets/HealBarFinished.tres")
	else:
		healBar.texture_progress = preload("res://UI/Assets/HealBarUnfinished.tres")
	update_health(Vector2.ZERO)


func update_abilities() -> void:
	Utils.free_children(upgrades)
	for i in playerData.upgrades:
		var u = load(i)
		var icon = TextureRect.new()
		icon.texture = u.miniIcon
		upgrades.add_child(icon)


func _on_just_lost_timer_timeout() -> void:
	justLostTween.stop_all()
	justLostTween.interpolate_property(
		justLostBar, "rect_size", justLostBar.rect_size,
		healthBar.rect_size, .2
	)
	justLostTween.start()

func _on_item_picked_up(_id) -> void: show()
