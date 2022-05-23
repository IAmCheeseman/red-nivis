extends Area2D

onready var collisionShape = $CollisionShape2D

export(Script) var effect
export var maskedHurtbox := ""
export var damage = 15
export var kbStrengh = 3.0
export var setDirection:Vector2
export var tick := -1.0
export var tickRightAway := false
export var giveSelf := false

var canHit = false

signal hit_object

func _on_Hitbox_area_entered(area):
	if area.is_in_group("hurtbox") and !area.is_in_group(maskedHurtbox):
		if tickRightAway:
			do_damage(area)
		if tick != -1.0:
			do_tick(area)
			return
		do_damage(area)


func do_tick(area) -> void:
	var timer = get_tree().create_timer(tick)
	timer.connect("timeout", self, "do_damage", [area])


func do_damage(area) -> void:
	if area is String or damage == 0: return
	if tick != -1.0 and area in get_overlapping_areas(): do_tick(area)
	emit_signal("hit_object", area)
	if !is_instance_valid(area): return

	var dir = global_position.direction_to(area.global_position)*kbStrengh

	if setDirection: dir = setDirection
	if !giveSelf:
		area.take_damage(damage, dir)
	else:
		area.take_damage(damage, dir, self)

	var par = area.get_parent()
	if effect and !par.has_node("Effect"):
		var newEffect = Node2D.new()
		newEffect.name = "Effect"
		newEffect.set_script(effect)
		newEffect.hurtbox = area
		par.add_child(newEffect)
