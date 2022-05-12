extends Node

var tween: Tween
var audio: AudioStreamPlayer
var targetTrack: AudioStreamOGGVorbis

func _ready() -> void:
	tween = Tween.new()
	add_child(tween)
	var _discard = tween.connect("tween_all_completed", self, "set_new_track")
	
	audio = AudioStreamPlayer.new()
	audio.bus = "SFX"
	add_child(audio)


func set_music(newTrack: AudioStreamOGGVorbis) -> void:
#	var _discard0 = tween.interpolate_property(
#		audio, "volume_db",
#		0, -80, 1 
#	)
#	var _discard1 = tween.start()
	
	targetTrack = newTrack
	
	set_new_track()


func set_new_track() -> void:
	audio.stop()
	audio.stream = targetTrack
	audio.play()
	
#	var _discard0 = tween.interpolate_property(
#		audio, "volume_db",
#		-80, 0, 1
#	)
#	var _discard1 = tween.start()
	


