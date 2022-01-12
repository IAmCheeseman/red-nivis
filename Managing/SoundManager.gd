extends Node2D
class_name SoundManager

export var audio : AudioStream
export var directional = false
export(float, -80, 24) var volumeMod = 0
export var pitchShiftRange:float = 1
export(String, "Master", "Ambient", "Music", "SFXMain", "SFX") var bus = 0

signal finished


func play(volMod=volumeMod):
	# Creating the audio player
	if !audio: return
	
	var newAudioPlayer
	match directional:
		true:
			newAudioPlayer = AudioStreamPlayer2D.new()
		false:
			newAudioPlayer = AudioStreamPlayer.new()

	# Setting parameters
	newAudioPlayer.stream = audio
	newAudioPlayer.bus = bus
	newAudioPlayer.autoplay = true
	newAudioPlayer.volume_db = volMod
	newAudioPlayer.pitch_scale = rand_range(1, pitchShiftRange)
	newAudioPlayer.connect("finished", self, "_on_audio_finished", [newAudioPlayer])

	add_child(newAudioPlayer)


func _on_audio_finished(player):
	emit_signal("finished")
	player.queue_free()


# Making sure sounds can't pile up and play all at once.
func _on_SoundManager_tree_exiting():
	for c in get_children():
		c.queue_free()
