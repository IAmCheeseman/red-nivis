extends Node

var tween: Tween
var audio: AudioStreamPlayer
var targetTrack: AudioStream
var secondsIn := 0.0

func _ready() -> void:
	tween = Tween.new()
	add_child(tween)
	var _discard = tween.connect("tween_all_completed", self, "set_new_track")
	
	audio = AudioStreamPlayer.new()
	audio.bus = "Music"
	add_child(audio)


func set_music(newTrack: AudioStream, si:=0.0) -> void:
#	var _discard0 = tween.interpolate_property(
#		audio, "volume_db",
#		0, -80, 1 
#	)
#	var _discard1 = tween.start()
	secondsIn = si
	targetTrack = newTrack
	
	set_new_track()


func set_new_track() -> void:
	audio.stop()
	audio.stream = targetTrack
	audio.play(secondsIn)
	
#	var _discard0 = tween.interpolate_property(
#		audio, "volume_db",
#		-80, 0, 1
#	)
#	var _discard1 = tween.start()
	


