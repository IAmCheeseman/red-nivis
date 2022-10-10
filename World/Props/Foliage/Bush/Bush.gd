extends Node2D

const PARTICLES = preload("res://World/Props/Foliage/Bush/BushExplode.tscn")

onready var playerDetection = $PlayerDetection
onready var sprite := $Sprite
onready var anim := $AnimationPlayer


func _process(delta):
	if playerDetection.get_player():
		var new_particles := PARTICLES.instance()
		new_particles.global_position = global_position
		GameManager.spawnManager.spawn_object(new_particles)
		
		sprite.frame += 1
		sprite.rotation = 0
		
		playerDetection.queue_free()
		anim.queue_free()
		
		set_script(null)
