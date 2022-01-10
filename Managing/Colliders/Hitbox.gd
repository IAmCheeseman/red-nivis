extends Area2D

onready var collisionShape = $CollisionShape2D

export var maskedHurtbox := ""
export var damage = 15
export var kbStrengh = 3
export var setDirection:Vector2
export var tick := -1.0

var canHit = false

signal hit_object

func _on_Hitbox_area_entered(area):
	if area.is_in_group("hurtbox") and !area.is_in_group(maskedHurtbox):
		if tick != -1.0:
			do_tick(area)
			return
		do_damage(area)


func do_tick(area) -> void:
	var timer = get_tree().create_timer(tick)
	timer.connect("timeout", self, "do_damage", [area])


func do_damage(area) -> void:
	if tick != -1.0 and get_overlapping_areas().size() == 0: return
	elif tick != -1.0: do_tick(area)
	emit_signal("hit_object", area)
	if !is_instance_valid(area): return
	
	var dir = global_position.direction_to(area.global_position)*kbStrengh
	
	if setDirection: dir = setDirection
	area.take_damage(damage, dir)
