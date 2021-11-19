extends TileMap


func _ready() -> void:
	add_timer()


func add_timer() -> void:
	var timer = get_tree().create_timer(rand_range(.1, 2))
	timer.connect("timeout", self, "_drop_debris")


func _drop_debris() -> void:
	var debris = Debris.new()
	var cells = get_used_cells()
	cells.shuffle()
	debris.position = cells.front()*cell_size+cell_size*.5
	debris.sprite = preload(\
		"res://World/Props/TempStuff/FallingRock.png")
	debris.z_index = -1
	add_child(debris)
	
	add_timer()
