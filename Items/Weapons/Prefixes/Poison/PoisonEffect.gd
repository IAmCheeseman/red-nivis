extends Node2D

var damage : float
var hurtboxTarget : Hurtbox
var maxHurtTime = 10
var hurtTime = 0

# Setting the stats
func callEffect(stats:Dictionary, target:Hurtbox):
	damage = 4*(stats.damage/10)
	hurtboxTarget = target

# Taking damage
func _on_poison_timeout():
	hurtboxTarget.take_damage(damage, Vector2.RIGHT.rotated(rand_range(0, 360)))
	hurtTime += 1
	if hurtTime >= maxHurtTime:
		queue_free()
