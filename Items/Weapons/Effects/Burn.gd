extends Node

var timer: Timer
var tick: float = .4
var lifetime: float = tick * 8
var dmg: int = 6
var hurtbox: Area2D

var particles: Particles2D

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = tick
	timer.autostart = true
	add_child(timer)
	var _discard0 = timer.connect("timeout", self, "_do_dmg")
	
	var lttimer = Timer.new()
	lttimer.wait_time = lifetime
	lttimer.autostart = true
	add_child(lttimer)
	var _discard1 = lttimer.connect("timeout", self, "_finish")
	
	var par = get_parent()
	if !par is KinematicBody2D: par = par.get_parent()
	var sprite = par.get_node("Sprite")
	
	particles = preload("res://Items/Weapons/Effects/BurnEffect.tscn").instance()
	particles.process_material = particles.process_material.duplicate()
	particles.process_material.emission_sphere_radius = (sprite.texture.get_width() / sprite.hframes)/ 2
	sprite.add_child(particles)


func _finish() -> void:
	particles.emitting = false
	queue_free()

func _do_dmg() -> void:
	hurtbox.take_damage(dmg, Vector2.ZERO)
