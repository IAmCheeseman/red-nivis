extends TextureProgress


func _process(delta):
	modulate.a = lerp(modulate.a, 0, (1.5*(1.0-(modulate.a-.01)))*delta)
