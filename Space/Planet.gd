extends Area2D
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
onready var collision = $CollisionShape2D

var oRots = {
	"planet" : rand_range(0, 360),
	"moon" : rand_range(0, 360)
}
var world = preload("res://World.tscn")


func _ready():
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = float(sprite.texture.get_height())/2
	set_tex(texture)


func _physics_process(delta):
	orbit(self, Vector2.ZERO, orbitSpeed, orbitDistance, rotationSpeed, "planet", delta)
	orbit($Moon, global_position, moonOrbitSpeed, moonOrbitDistance, moonRotationSpeed, "moon", delta)


func orbit(node:Node2D, orbitPoint:Vector2, oSpeed, oDist, rSpeed, oRot, delta):
	node.global_rotation_degrees += rSpeed*delta
	
	if !canOrbit:
		return
	
	oRots[oRot] += (oSpeed/oDist)*delta
	var orbit = Vector2.RIGHT.rotated(oRots[oRot])
	if faceTravelDir: look_at(orbit)
	orbit *= oDist
	orbit += orbitPoint
	node.global_position = orbit


func _on_Planet_body_entered(body):
	if body.is_in_group("playerShip") and planet != -1:
		GameManager.planet = planet
# warning-ignore:return_value_discarded
		if altLoadPath != "":
			get_tree().change_scene(altLoadPath)
			return
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(world)
		


func set_tex(_texture):
	texture = _texture
	$Sprite.texture = texture
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = float($Sprite.texture.get_height())/2


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

