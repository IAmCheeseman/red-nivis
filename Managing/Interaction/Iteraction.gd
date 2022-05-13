extends Area2D

const PLAYER = preload("res://Entities/Player/Player.tres")


onready var label:RichTextLabel = $Label
onready var anim := $AnimationPlayer
onready var pointer := $Pointer


export var ignoreDistance := false
export var disabled := false setget set_disabled
export var spritePath:NodePath
export var requireInput:bool = true
export var action: String = "interact"

var sprite:Sprite

var playerNear = false
var emittedClose = false
var isVisible := false

signal interaction
signal player_close
signal player_left


func _ready() -> void:
	update_label()
	set_process(false)
	# Adding an outline shader to a sprite
	pointer.modulate.a = 0
	
	if !has_node(spritePath): return
	sprite = get_node(spritePath)
	if !sprite.material:
		sprite.material = ShaderMaterial.new()
		sprite.material.shader = preload("res://General/Outline.shader")
		sprite.material.set_shader_param("line_thickness", 0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		# Checking if it's the player and
		# Emitting a signal if it's the player
		if playerNear and is_closest() and !disabled and !GameManager.inGUI:
			emit_signal("interaction")


func _physics_process(delta: float) -> void:
	var font = label.get_font("normal_font")
	label.rect_size = font.get_string_size(label.text) + (Vector2.ONE * 16)
	
	label.rect_position.x = -label.rect_size.x / 2
	label.rect_position.y = pointer.rect_position.y - (label.rect_size.y / 2)
	
	label.modulate = pointer.modulate


func _process(_delta: float) -> void:
	if !disabled and is_closest() and playerNear:
		set_visibility(true)
		if !emittedClose:
			emit_signal("player_close")
			emittedClose = true
		if sprite: sprite.material.set_shader_param("line_thickness", 1)
	else:
		set_visibility(false)
		if sprite: sprite.material.set_shader_param("line_thickness", 0)
		emittedClose = false
	set_process(playerNear)


# Updating player status and emitting signals
# based on player position
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		# If no input is required, emit the interaction signal right away, and cancel.
		if !requireInput:
			emit_signal("interaction")
			return
		playerNear = true
		# Setting the label to show correct key
		update_label()
		# If it's not disabled and it's
		# closest to the player, show the prompt
		set_process(true)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		playerNear = false
		if !disabled:
			set_visibility(false)
			emit_signal("player_left")
		if sprite: sprite.material.set_shader_param("line_thickness", 0)


# Checks if the player is closest to this interactable.
# Bad code, but it works since there's
# not going to be a huge number of 
# interactables in the scene at a time
func is_closest() -> bool:
	var dist = global_position.distance_to(
		PLAYER.playerObject.global_position)
	for i in get_tree().get_nodes_in_group("interactable"):
		if i.global_position.distance_to(
			PLAYER.playerObject.global_position) < dist:
			return false
	return true

# Sets `disabled` to `val`
func set_disabled(val: bool):
	if disabled == val: return
	
	disabled = val 
	if !label or !sprite: return
	if disabled:
		set_visibility(false)
		sprite.material.set_shader_param("line_thickness", 0)
	elif get_overlapping_areas().size() > 0 and is_closest():
		set_visibility(true)
		sprite.material.set_shader_param("line_thickness", 1)


func set_visibility(vis: bool) -> void:
	if isVisible == vis: return
	if disabled:
		anim.play_backwards("PointerIn")
		isVisible = false
		return
	isVisible = vis
	if vis:
		anim.play("PointerIn")
	else:
		anim.play_backwards("PointerIn")
	


# Updates the label, and centers it
func update_label() -> void:
	label.bbcode_text = "[center]%s[/center]" % [tr(action)]
#	label.bbcode_text = label.bbcode_text.replace(
#		"<interact>",
#		"<%s>" % OS.get_scancode_string(InputMap.get_action_list("interact")[0].scancode)
#	)
	#OS.get_scancode_string(InputMap.get_action_list("interact")[0].scancode), action
