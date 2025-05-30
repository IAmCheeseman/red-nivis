extends Node2D
class_name SoundManager

export var audio : AudioStream
export var directional = false
export(float, -80, 24) var volumeMod = 0.0
export(float, 1, 100) var pitchShiftRange:float = 1
export var autoplay := false
export var loop := false
export var attenuation := 5.0
export var maxDist := 2000.0
export var freeOnFinish := false
export(String, "Master", "Ambient", "Music", "SFX", "Reverb", "ReverbLow") var bus

signal finished


func _ready() -> void:
	if autoplay: play()


func play(volMod=volumeMod):
	# Creating the audio player
	if !audio: return

	var newAudioPlayer
	match directional:
		true:
			newAudioPlayer = AudioStreamPlayer2D.new()
			newAudioPlayer.attenuation = attenuation
			newAudioPlayer.max_distance = maxDist
		false:
			newAudioPlayer = AudioStreamPlayer.new()
		_:
			push_error("What.")

	# Setting parameters
	newAudioPlayer.stream = audio
	newAudioPlayer.bus = bus
	newAudioPlayer.autoplay = true
	newAudioPlayer.volume_db = volMod
	newAudioPlayer.pitch_scale = rand_range(1, pitchShiftRange)
	newAudioPlayer.connect("finished", self, "_on_audio_finished", [newAudioPlayer])

	add_child(newAudioPlayer)


func stop() -> void: Utils.free_children(self)


func _on_audio_finished(player):
	emit_signal("finished")
	if freeOnFinish:
		queue_free()
		return
	if loop:
		player.play()
		return
	player.queue_free()


# Making sure sounds can't pile up and play all at once.
func _on_SoundManager_tree_exiting():
	for c in get_children():
		c.queue_free()
