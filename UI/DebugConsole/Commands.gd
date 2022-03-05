extends Control

var player = preload("res://Entities/Player/Player.tres")
var mapData = GameManager.worldData


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
 time_scale(scale)
 toggle_revealed_map()
 op()
 give(item_id)
"""


func toggle_revealed_map():
	GameManager.revealMap = !GameManager.revealMap
	return " Map reveal toggled"


func give(item: String) -> String:
	if !ItemMap.ITEMS.has(item): 
		return " Invalid id: %s" % item
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	inventory.add_item(item)
	return " Gave %s" % ItemMap.ITEMS[item].name


func l(amt=1) -> String:
	mapData.position.x -= amt
	mapData.moveDir = Vector2.LEFT
	var _discard = get_tree().reload_current_scene()
	return ""
func r(amt=1) -> String:
	mapData.position.x += amt
	mapData.moveDir = Vector2.RIGHT
	var _discard = get_tree().reload_current_scene()
	return ""
func u(amt=1) -> String:
	mapData.position.y -= amt
	mapData.moveDir = Vector2.UP
	var _discard = get_tree().reload_current_scene()
	return ""
func d(amt=1) -> String:
	mapData.position.y += amt
	mapData.moveDir = Vector2.DOWN
	var _discard = get_tree().reload_current_scene()
	return ""


func ability(n: String) -> String:
	var a := ""
	match n:
		"teleport": 
			a = "res://Items/Upgrades/Teleport/Teleport.tres"
		"boots":
			a = "res://Items/Upgrades/DoubleJump/DoubleJump.tres"
		"gloves":
			a = "res://Items/Upgrades/StickyGlove/WallJump.tres"
		"grenade":
			a = "res://Items/Upgrades/Grenade/Grenade.tres"
		"hookshot":
			a = "res://Items/Upgrades/Hookshot/Hookshot.tres"
		_:
			return " That ability does not exist"
	player.upgrades.append(a)
	player.emit_signal("updateAbilities")
	return " Gave %s" % n


func clear_inven() -> String:
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	inventory.items.clear()
	return " Inventory cleared"


func time_scale(time_scale):
	Engine.time_scale = time_scale
	return " Set time scale to %s" % time_scale


func op():
	
	return toggle_godmode()+"\n"+toggle_revealed_map()


func echo(output:String) -> String:
	return " " + output


func toggle_godmode() -> String:
	player.godmode = !player.godmode
	return " Set godmode to %s" % str(player.godmode)


func go_to(path:String) -> String:
	var _discard = get_tree().change_scene(path)
	return ""


func reload() -> String:
	var _discard = get_tree().reload_current_scene()
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
