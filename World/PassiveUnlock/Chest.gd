extends Node2D

onready var anim = $AnimationPlayer
onready var interactionZone = $Iteraction
onready var sprite = $Sprite
onready var standPos = $"6amPos"
onready var particles = $Particles2D

signal open

var opened := false


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	if GameManager.worldData.rooms.size() == 0: return
	var isOpened = GameManager.worldData.get_room_data(self, false)
	if isOpened:
		opened = true
		interactionZone.disabled = true
		particles.hide()
		anim.play("Open")


func _on_interaction() -> void:
	emit_signal("open")
	GameManager.worldData.store_room_data(self, true)
	interactionZone.disabled = true


func open() -> void:
	if opened: return
	opened = true
	
	var worldData = GameManager.worldData
	var biome
	var items
	
	if worldData.rooms.size() != 0:
		biome = worldData.get_biome_by_index(worldData.rooms\
			[worldData.position.x][worldData.position.y].biome)
		items = ItemMap.get_passive_list(biome.name)
	else:
		items = ItemMap.get_passive_list()
	
	var passive = items[rand_range(0, items.size())]
	while passive in worldData.acquiredPassives:
		passive = items[rand_range(0, items.size())]
	worldData.acquiredPassives.append(passive)
	
	var newPassive = preload("res://Items/Passives/DroppedPassive.tscn").instance()
	newPassive.item = load(items[rand_range(0, items.size())])
	newPassive.global_position = global_position - Vector2(0, 12)
	newPassive.apply_central_impulse(Vector2(rand_range(-24, 24), -75))
	GameManager.spawnManager.spawn_object(newPassive)
