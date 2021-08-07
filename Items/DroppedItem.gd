extends RigidBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var pickUpArea = $PickUpZone
onready var pickUpCollision = $PickUpZone/CollisionShape2D
onready var pickUpAnim = $PickUp
onready var itemGlow = $ItemGlow
onready var trail = $Trail

export var item:String = "Cheese"

var inventory:Inventory = preload("res://UI/Inventory/Inventory.tres")
var player = null

func _ready():
	# Setting the sprite
	sprite.texture = inventory.itemMap[item].texture
	# Setting collisions
	collision.shape.extents = Vector2(
		sprite.texture.get_width(), sprite.texture.get_height()
	)/2
	pickUpCollision.shape = collision.shape

	var tierColor = GameManager.itemManager.tierColors[inventory.itemMap[item].rarity]

	itemGlow.distNear = sprite.texture.get_width()*1.25
	itemGlow.distFar = itemGlow.distNear*1.25
	itemGlow.color = tierColor
	trail.default_color = tierColor



func _process(_delta):
	if pickUpAnim.is_playing():
		position += position.direction_to(player.position-Vector2(0, 16))


func _input(event):
	# Picking up the item
	if player and event.is_action_pressed("interact") and inventory.has_space():
		inventory.add_item(item)
		pickUpAnim.play("PickUp")
		pickUpArea.disconnect("area_exited", self, "_on_player_far")


func _on_player_close(area):
	player = area.get_parent()


func _on_player_far(_area):
	player = null
