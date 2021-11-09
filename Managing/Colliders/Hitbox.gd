extends Area2D


export var maskedHurtbox := ""
export var damage = 15
export var kbStrengh = 3

var setDirection:Vector2

signal hit_object

func _on_Hitbox_area_entered(area):
	if area.is_in_group("hurtbox") and !area.is_in_group(maskedHurtbox):
		emit_signal("hit_object", area)
		var dir = global_position.direction_to(area.global_position)*kbStrengh
		if setDirection: dir = setDirection
		area.take_damage(damage, dir)

