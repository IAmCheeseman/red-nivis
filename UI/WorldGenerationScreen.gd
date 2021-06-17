extends Control

onready var worldManager = $WorldManager
onready var percentageLab = $CenterContainer/LoadingBar/Percentage


func start_generation():
	var thread = Thread.new()
	thread.start(worldManager, "generate_world", thread)


func world_gen_updated(percentage):
	percentageLab.text = str(stepify(percentage, 0.1))+"%"


func _on_world_gen_finished():
	$Transitions.play("FadeOut")


func play():
	get_tree().change_scene("res://WorldGeneration/World.tscn")
