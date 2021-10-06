extends Control

var player = preload("res://Entities/Player/Player.tres")
var mapData = preload("res://World/WorldManagement/WorldData.tres")


func help() -> String:
	return """ -= HELP =-
 echo(msg)
 toggle_godmode()
 go_to(path)
 reload()
 set_health(amount)
 set_max_health(amount)
 set_money(amount)
 tp(x, y)
 set_room(x, y)
"""


func echo(output:String) -> String:
	return " " + output


func toggle_godmode() -> String:
	player.godmode = !player.godmode
	return " Set godmode to %s" % str(player.godmode)


func go_to(path:String) -> String:
	get_tree().change_scene(path)
	return ""


func reload() -> String:
	get_tree().reload_current_scene()
	return ""


func set_health(value:int) -> String:
	player.health = value
	return " Changed health to %s." % str(value)


func set_max_health(value:int) -> String:
	player.maxHealth = value
	player.health = value
	return " Changed max health to %s." % str(value)


func set_money(value:int) -> String:
	player.money = value
	return " Set money to %s." % str(value)


func set_room(x, y) -> String:
	if !mapData.rooms[x][y].biome:
		return " That room has no set biome."
	mapData.position = Vector2(x, y)
	var _discard = get_tree().reload_current_scene()
	return " Set room pos to %s" % str(Vector2(x, y))


func tp(x, y) -> String:
	player.playerObject.position = Vector2(x, y)
	return " Teleported to %s." % str(Vector2(x, y))
