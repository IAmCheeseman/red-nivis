extends Area2D

onready var sprite := $Sprite
onready var tween := $Tween


func _ready() -> void:
	sprite.rotation = rand_range(0, PI * 2)
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, .1)
	tween.start()



func _process(delta: float) -> void:
	var areas = get_overlapping_areas()
	for i in areas:
		if i.is_in_group("player"):
			i.owner.vel *= .75

func take_damage(_amt, _kb) -> void: pass

func queue_free() -> void:
	tween.stop_all()
	tween.interpolate_property(self, "scale", scale, Vector2.ZERO, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	self.queue_free()
