extends RigidBody2D

onready var collision = $CollisionShape2D
#onready var pickUpArea = $PickUpZone
onready var pickUpCollision = $Iteraction/CollisionShape2D
onready var pickUpAnim = $PickUp
onready var itemGlow = $ItemGlow
onready var trail = $Trail
onready var sprite = $Sprite

var item:Dictionary

var inventory:Inventory = preload("res://UI/Inventory/Inventory.tres")
var isPickedUp = false

func _ready():
	# Setting the sprite
	sprite.texture = load(item.slotTexture)
	# Setting collisions
	collision.shape.extents = Vector2(4, 4)
	pickUpCollision.shape = collision.shape
	
	var tierColor = Color.orange

	itemGlow.distNear = 16
	itemGlow.distFar = itemGlow.distNear*1.25
	itemGlow.color = tierColor
	trail.default_color = tierColor


func pick_up():
	# Picking up the item
	if !isPickedUp:
		if !inventory.has_space():
			var newItem = GameManager.itemManager.create_item(inventory.items[inventory.selectedSlot].itemData.key)
			newItem.position = position
			GameManager.spawnManager.spawn_object(newItem)
			inventory.remove_item(inventory.selectedSlot)
		inventory.add_item(item.key)
		pickUpAnim.play("PickUp")
		pickUpCollision.disabled = true
		isPickedUp = true

