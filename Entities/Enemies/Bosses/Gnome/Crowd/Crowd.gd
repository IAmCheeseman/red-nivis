extends Node2D

onready var stands = $TileMap
onready var boo = $Boo
onready var woo = $Woo
onready var dialogs = $Dialogs


const GNOMES = preload("res://Entities/Enemies/Bosses/Gnome/Crowd/Gnomes.png")
const STAND = preload("res://Entities/Enemies/Bosses/Gnome/Crowd/Stand.png")

var currentSeed = 0
var addBounces = true
var start: float
var end: float
var currDialog := 0

var gnomes = []

func _ready() -> void:
	GameManager.player.playerData.connect("healthChanged", self, "play_woo")
	GameManager.player.playerData.connect("healsChanged", self, "_on_player_heal")
	
	stands.hide()
	var cells = stands.get_used_cells()
	start = cells[0].y
	end = cells[cells.size()-1].y
	
	# Adding nodes
	var lastUpdatedY = 0
	var yNode
	for i in stands.get_used_cells():
		if lastUpdatedY != i.y:
			lastUpdatedY = i.y
			yNode = Node2D.new()
			add_child(yNode)
		var mod = Color(1, 1, 1, 1)
		mod.r = ((i.y - start) / end) + .15
		mod.g = mod.r
		mod.b = mod.r
		
		var newStand = Sprite.new()
		newStand.texture = STAND
		newStand.position = stands.map_to_world(i)
		newStand.centered = false
		newStand.modulate = mod
		newStand.show_behind_parent = int(i.x) % 2 == 1
		yNode.add_child(newStand)
		
		if rand_range(0, 1) < .25: continue
		
		var frameCount = Vector2(3, 4)
		var spriteSize = GNOMES.get_size()
		var frameSize = (spriteSize / frameCount)
		
		var drawRect = Rect2(0,0,0,0)
		drawRect.position = Vector2(
			(spriteSize.x - frameSize.x) * rand_range(0, 1),
			(spriteSize.y - frameSize.y) * rand_range(0, 1)
		).snapped(frameSize)
		drawRect.size = frameSize
		
		var spritePosition = Vector2(0, -((int(Utils.coin_flip()) * rand_range(1, 3)) + 15))
		
		var newGnome = Sprite.new()
		newGnome.texture = GNOMES
		newGnome.region_enabled = true
		newGnome.region_rect = drawRect
		newGnome.position = spritePosition
		newGnome.centered = false
		newGnome.show_behind_parent = true
		newStand.add_child(newGnome)

		gnomes.append(newGnome)


func _process(delta: float) -> void:
	var uniqueness = 0
	for i in gnomes:
		seed(currentSeed + uniqueness)
		var targetY = -(rand_range(0, 3) + 15)
		i.flip_h = Utils.coin_flip()
		i.position.y = lerp(i.position.y, targetY, 24 * delta)
		uniqueness += 1


func _on_timeout() -> void:
	randomize()
	currentSeed = randi()


func random_dialog(isBoo: bool) -> void:
	randomize()
	var prefix = "Cheer"
	if isBoo: prefix = "Boo"
	dialogs.get_child(currDialog).start_dialog(prefix + str(floor(rand_range(1, 4))))
	currDialog += 1
	currDialog = wrapi(currDialog, 0, dialogs.get_child_count())


func play_boo() -> void:
	boo.play()
	random_dialog(true)
func play_woo(_lmao=Vector2.ZERO) -> void:
	woo.play()
	random_dialog(false)

func _on_player_heal() -> void:
#	woo.stop()
	play_boo()
