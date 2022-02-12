extends Area2D

const PLAYER = preload("res://Entities/Player/Player.tres")

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

export var upgrade: Resource = preload("res://Items/Upgrades/Teleport/Teleport.tres")

var unlocked := false


func _ready() -> void:
	sprite.texture = upgrade.hologramSprite


func _process(_delta: float) -> void:
	if unlocked: return
	sprite.modulate.a = 1 - (global_position.distance_to(GameManager.player.global_position) / 200)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and !unlocked:
		anim.play("GiveSchematic")
		give_schematic()
		unlocked = true


func give_schematic() -> void:
	var pth = upgrade.resource_path
	if pth in PLAYER.unlockedUpgrades: return
	PLAYER.unlockedUpgrades.append(pth)
