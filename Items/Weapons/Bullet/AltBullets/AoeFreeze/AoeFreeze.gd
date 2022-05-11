extends Area2D


var currentAreas = []


func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")



func _process(delta: float) -> void:
	for i in currentAreas:
		i.vel *= 0.5 * delta


func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("EnemyBullet"): return
	var node = area.get_parent()
	while !node is KinematicBody2D:
		node = node.get_parent()
	currentAreas.append(node)
	node.modulate = Color(0,0,1)


func _on_area_exited(area: Node2D) -> void:
	if area.is_in_group("EnemyBullet"): return
	var node = area.get_parent()
	while !node is KinematicBody2D:
		node = node.get_parent()
	
	currentAreas.erase(node)
	node.modulate = Color(1,1,1)
