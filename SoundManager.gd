extends Node2D
class_name SoundManager

export var audio : AudioStream
export var directional = false
export(float, -80, 24) var volumeMod = 0
export(String, "Master", "Ambient", "Music", "SFX") var bus = 0


func play():
	var newAudioPlayer
	match directional:
		true:
			newAudioPlayer = AudioStreamPlayer2D.new()
		false:
			newAudioPlayer = AudioStreamPlayer.new()
	newAudioPlayer.stream = audio
	newAudioPlayer.bus = bus
	newAudioPlayer.autoplay = true
	newAudioPlayer.volume_db = volumeMod
	newAudioPlayer.connect("finished", self, "_on_audio_finished", [newAudioPlayer])
	add_child(newAudioPlayer)


func _on_audio_finished(player):
	player.queue_free()
