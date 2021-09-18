extends RigidBody2D

onready var collision = $CollisionShape2D
onready var pickUpArea = $PickUpZone
onready var pickUpCollision = $PickUpZone/CollisionShape2D
onready var pickUpAnim = $PickUp
onready var itemGlow = $ItemGlow
onready var trail = $Trail

var item:Dictionary

var inventory:Inventory = preload("res://UI/Inventory/Inventory.tres")
var player = null
var isPickedUp = false

func _ready():
	# Setting the sprite
#	sprite.add_child()
	add_child(item.scene.duplicate())
	# Setting collisions
	collision.shape.extents = Vector2(4, 4)
	pickUpCollision.shape = collision.shape
	
	var tierColor = Color.orange

	itemGlow.distNear = 16
	itemGlow.distFar = itemGlow.distNear*1.25
	itemGlow.color = tierColor
	trail.default_color = tierColor

#	sprite.material = sprite.material.duplicate()
#	sprite.material.set_shader_param("line_color", tierColor)


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
