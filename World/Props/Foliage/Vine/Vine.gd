extends StaticBody2D

const SEG_HEIGHT = 8

onready var queueArea = $queueArea

export var length = 12

var vineSeg = preload("res://World/Props/Foliage/Vine/Middle.tscn")
var vineEnd = preload("res://World/Props/Foliage/Vine/Bottom.tscn")
var vineBegin = preload("res://World/Props/Foliage/Vine/Top.tscn")


func _ready() -> void:
#	if queueArea.get_overlapping_areas().size() > 0:
#		queue_free()
#	queueArea.queue_free()
	length = round(rand_range(3, 5))
	
	var prevPin := PinJoint2D.new()
	prevPin.disable_collision = true
	prevPin.softness = 0
	prevPin.node_a = get_path()
	add_child(prevPin)
	
	
	for i in length:
		var newVineSeg
		if i == 0:
			newVineSeg = vineBegin.instance()
		elif i == length-1:
			newVineSeg = vineEnd.instance()
		else:
			newVineSeg = vineSeg.instance()
		newVineSeg.position.y = i*SEG_HEIGHT
		newVineSeg.mass = 3
		newVineSeg.gravity_scale = 9.8/2
		add_child(newVineSeg)
		
		prevPin.node_b = newVineSeg.get_path()
		
		prevPin = prevPin.duplicate()
		prevPin.position = newVineSeg.position+Vector2(0, SEG_HEIGHT)
		prevPin.node_a = newVineSeg.get_path()
		add_child(prevPin)
		


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_item"):
		get_child(get_child_count()-2).apply_central_impulse(Vector2.RIGHT.rotated(deg2rad(rand_range(0, 360)))*100)
