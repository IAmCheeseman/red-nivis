extends Node2D

onready var solids = $Solids
onready var player = $Player
onready var particleContainer = $AtmosphereParticles
onready var atmosphere = $Atmosphere

func _ready():
	var shadows = solids.duplicate()
	shadows.position.y += 12
	shadows.modulate = Color(0, 0, 0, .5)
	shadows.show_behind_parent = true
	shadows.cell_y_sort = false
	shadows.collision_layer = 0
	solids.add_child(shadows)

	# Setting atmosphere
	if GameManager.planet is Planet:

		atmosphere.color = GameManager.planet.atmosphereColor
		solids.material.set_shader_param("newColor", GameManager.planet.ruinColor)
		if GameManager.planet.amosphereParticles:
			var atmosphereParticles = GameManager.planet.amosphereParticles.instance()
			particleContainer.add_child(atmosphereParticles)
		else:
			print("NO AMBIENT PARTICLES DEFINED FOR PLANET")

	# adding weapons

	var invalidCells = solids.get_used_cells()
	var limits = solids.get_used_rect().end
	var weaponCount = 3

	var gun = preload("res://Items/Weapons/Gun.tscn")
	for i in weaponCount:
		var newWeapon = gun.instance()

		while true:
			newWeapon.position = (Vector2(rand_range(0, limits.x), rand_range(0, limits.y))*16).snapped(Vector2(16, 16))
			if !newWeapon.position/16 in invalidCells and newWeapon.position.distance_to(player.position) > 16*2:
				break
		newWeapon.position += Vector2(8, 8)
		add_child(newWeapon)
