extends Node2D

onready var sprite = $Sprite
onready var damager = $Damager
onready var fire = $Fire
onready var toggleTimer = $ToggleTimer

var player: Node2D

const ARM_POSITIONS := [Vector2(-3, -9), Vector2(3, -4)]

export var DMGRange := 65

var prevRot := 0.0


func _ready() -> void:
	toggle()
	toggleTimer.start(rand_range(.2, 2))


func _process(delta: float) -> void:
	if !player: return
	look_at(player.global_position-Vector2(0, 8))
	sprite.flip_v = Vector2.RIGHT.rotated(rotation).x < 0
	position = ARM_POSITIONS[int(sprite.flip_v)]
	position.x *= get_parent().sprite.scale.x
	
	var weight = 10 * delta
	weight *= global_position.distance_to(player.global_position) / 100
	damager.global_rotation = lerp_angle(prevRot, rotation, weight)
	
	prevRot = damager.global_rotation


func toggle() -> void:
	if !player: damager.monitoring = true
	damager.monitoring = !damager.monitoring
	fire.emitting = damager.monitoring
	toggleTimer.start(rand_range(.8, 2))
