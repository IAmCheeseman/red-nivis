extends Node

var damage : float
var hurtboxTarget : Hurtbox

# Setting the stats
func callEffect(stats:Dictionary, target:Hurtbox):
	damage = 4*(stats.damage/10)
	hurtboxTarget = target

# Taking damage
func _on_poison_timeout():
	hurtboxTarget.take_damage(damage)
