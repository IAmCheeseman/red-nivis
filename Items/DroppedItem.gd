extends RigidBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var pickUpArea = $PickUpZone
onready var pickUpCollision = $PickUpZone/CollisionShape2D
onready var anim = $AnimationPlayer

export var item:String = "Cheese"
export var stackSize:int = 1

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


func _input(event):
	# Picking up the item
	if player and event.is_action_pressed("interact"):
		inventory.add_item(item)
		anim.play("PickUp")


func _on_player_close(area):
	player = area.get_parent()
