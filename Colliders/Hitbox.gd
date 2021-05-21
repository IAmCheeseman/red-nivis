extends Area2D


export var maskedHurtbox := ""
export var damage = 15

signal hit_object

func _on_Hitbox_area_entered(area):
	if area.is_in_group("hurtbox") and !area.is_in_group(maskedHurtbox):
		area.take_damage(damage)
		emit_signal("hit_object")
