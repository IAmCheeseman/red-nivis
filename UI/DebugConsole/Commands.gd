extends Control

var player = preload("res://Entities/Player/Player.tres")


func echo(output:String) -> String:
	return output


func set_health(value:int) -> String:
	player.health = value
	return "Changed health to %s." % str(value)


func set_max_health(value:int) -> String:
	player.maxHealth = value
	player.health = value
	return "Changed max health to %s." % str(value)


func set_money(value:int) -> String:
	player.money = value
	return "Set money to %s." % str(value)


func tp(pos:Vector2) -> String:
	player.playerObject.position = pos
	return "teleported to %s." % str(pos)
