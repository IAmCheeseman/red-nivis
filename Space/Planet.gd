extends Node2D
tool

export var rotationSpeed = 90 setget set_rot_speed
export var orbitSpeed = 0.2 setget set_orb_speed
export var orbitDistance = 300 setget set_orb_dist
export var canOrbit = true setget set_orbit
export var faceTravelDir := false
export var moonTexture : Texture setget set_moon_tex
export var moonRotationSpeed = 90 setget set_moon_rot_speed
export var moonOrbitSpeed = .2 setget set_moon_orb_speed
export var moonOrbitDistance = 90 setget set_moon_orb_dist
export var atmosphereColor : Color setget set_at_color
export(float, 0, 5) var atmosphereStrength = 1 setget set_at_stre
export(float, 0, .5) var atmosphereSize = .2 setget set_at_size
export var texture : StreamTexture setget set_tex
export var planet : int
export var altLoadPath : String


onready var atmosphere = $Atmosphere
onready var sprite = $Sprite
onready var moon = $Moon
onready var button = $Button

var oRots = {
	"planet" : rand_range(0, 360),
	"moon" : rand_range(0, 360)
}


func _ready():
	set_tex(texture)


func _physics_process(delta):
	orbit(self, Vector2.ZERO, orbitSpeed, orbitDistance, rotationSpeed, "planet", delta)
	orbit($Moon, global_position, moonOrbitSpeed, moonOrbitDistance, moonRotationSpeed, "moon", delta)
	if button.get_rect().has_point(get_local_mouse_position())\
	and name != "Sun":
		scale = scale.move_toward(Vector2.ONE*1.2, 6*delta)
		if Input.is_action_just_pressed("use_item"):
			go_to_planet()
	else:
		scale = scale.move_toward(Vector2.ONE, 6*delta)


func orbit(node:Node2D, orbitPoint:Vector2, oSpeed, oDist, rSpeed, oRot, delta):
	node.global_rotation_degrees += rSpeed*delta

	if !canOrbit:
		return

	oRots[oRot] += (oSpeed/(oDist+1))*delta
	var orbit = Vector2.RIGHT.rotated(oRots[oRot])
	if faceTravelDir: look_at(orbit)
	orbit *= oDist
	orbit += orbitPoint
	node.position = orbit


func go_to_planet():
	GameManager.planet = planet
# warning-ignore:return_value_discarded
	if altLoadPath != "":
		get_tree().change_scene(altLoadPath)
		return
# warning-ignore:return_value_discarded
	var error = get_tree().change_scene("res://World/World.tscn")
	if error != OK:
		get_tree().quit()



func set_tex(_texture):
	texture = _texture
	$Sprite.texture = texture


func set_orbit(orb):
	canOrbit = orb


func set_at_color(color):
	atmosphereColor = color
	$Atmosphere.color = atmosphereColor


func set_at_stre(stre):
	atmosphereStrength = stre
	$Atmosphere.energy = atmosphereStrength


func set_rot_speed(rot):
	rotationSpeed = rot


func set_orb_dist(dist):
	orbitDistance = dist


func set_orb_speed(value):
	orbitSpeed = value


func set_moon_rot_speed(rot):
	moonRotationSpeed = rot


func set_moon_orb_dist(dist):
	moonOrbitDistance = dist


func set_moon_orb_speed(speed):
	moonOrbitSpeed = speed


func set_moon_tex(tex):
	moonTexture = tex
	$Moon.texture = moonTexture


func set_at_size(size):
	atmosphereSize = size
	$Atmosphere.texture_scale = atmosphereSize

