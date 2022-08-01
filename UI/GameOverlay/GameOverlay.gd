extends Control

var playerData = preload("res://Entities/Player/Player.tres")
var inventory = preload("res://UI/Inventory/Inventory.tres")

# Health Bar
onready var healthBar = $VBox/Health/VBoxContainer/HBoxContainer/HPBar
onready var healthLabel = $VBox/Health/VBoxContainer/HBoxContainer/Health

onready var healBar = $VBox/Health/HealProgress
onready var healBarTween = $VBox/Health/HealProgress/HealProgressTween

# Ammo bar
#onready var ammoBar = $VBox/Bottom/AmmoBar/Icons
onready var ammoBar = $VBox/Health/VBoxContainer/AmmoBar/TextureProgress
onready var reloadNotif = $VBox/Health/VBoxContainer/AmmoBar/ReloadNotif
onready var ammoTween = $VBox/Health/VBoxContainer/AmmoBar/Tween

onready var grenade = $VBox/Bottom/BombProgressBar

onready var upgrades = $TopRight/Upgrades

onready var time = $TopRight/Time

var JLTarget:Vector2
var ammoBarTexSize:Vector2


func _ready() -> void:
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
	update_abilities()

	yield(TempTimer.idle_frame(self, 2), "timeout")
	if inventory.is_empty(): hide()



func _process(_delta: float) -> void:
	if playerData.isReloading:
		reloadNotif.text = "..."
	else:
		reloadNotif.text = "%s/%s" % [playerData.ammo, playerData.maxAmmo]

	if Settings.speedrunTimer:
		var seconds = str(int(playerData.time) % 60)
		if seconds.length() == 1: seconds = "0"+seconds
# warning-ignore:integer_division
		var minutes = str(int(playerData.time) % 3600 / 60)
# warning-ignore:integer_division
		time.text = "Time \n%s:%s " % [minutes, seconds]
	else:
		time.text = ""


func update_health(_kb:Vector2) -> void:
	healthBar.value = playerData.health
	healthBar.max_value = playerData.maxHealth
	
	healthLabel.text = "%s/%s" % [playerData.health, playerData.maxHealth]



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


func _on_item_picked_up(_id) -> void: show()
