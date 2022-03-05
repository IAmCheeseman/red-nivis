extends VBoxContainer

onready var hpBar = $TextureProgress
onready var recntDmg = $TextureProgress/RecentDmg
onready var tween = $TextureProgress/Tween
onready var bossNameLbl = $Label

export var bossName := "Boss Name"
export var dmgManagerPth: NodePath
onready var damageManager = get_node(dmgManagerPth)


func _ready() -> void:
	recntDmg.max_value = damageManager.maxHealth
	recntDmg.value = damageManager.maxHealth
	update_bar()
	bossNameLbl.text = bossName
	damageManager.connect("damaged", self, "update_bar")


func update_bar() -> void:
	hpBar.max_value = damageManager.maxHealth
	hpBar.value = damageManager.health
	
	tween.interpolate_property(
		recntDmg, "value", recntDmg.value,
		hpBar.value, .5, Tween.TRANS_EXPO, Tween.EASE_IN
	)
	tween.start()
