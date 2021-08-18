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
var isPickedUp = false

func _ready():
	# Setting the sprite
	if item.is_valid_integer():
		sprite.add_child()
	else:
		sprite.texture = inventory.itemMap[item].texture
	# Setting collisions
		collision.shape.extents = Vector2(
			sprite.texture.get_width(), sprite.texture.get_height()
		)/2
		pickUpCollision.shape = collision.shape

	var tierColor = GameManager.itemManager.tierColors[inventory.itemMap[item].rarity]

	itemGlow.distNear = sprite.texture.get_width()*.625
	itemGlow.distFar = itemGlow.distNear*1.25
	itemGlow.color = tierColor
	trail.default_color = tierColor

	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_param("line_color", tierColor)


func _input(event):
	# Picking up the item
	if player and event.is_action_pressed("interact")\
	and inventory.has_space() and !isPickedUp:
		inventory.add_item(item)
		pickUpAnim.play("PickUp")
		pickUpArea.disconnect("area_exited", self, "_on_player_far")
		isPickedUp = true


func _on_player_close(area):
	if area.is_in_group("player"):
		player = area.get_parent()


func _on_player_far(area):
	if area.is_in_group("player"):
		player = null
