extends Reference
class_name ToolTipGenerator

const DMG_COLOR = Color.red
const COLON = "[color=#a8b5b2]:[/color]"

const PLAYER_DATA = preload("res://Entities/Player/Player.tres")


static func tooltips(data: Dictionary) -> String:
	var tooltip = ""
	
	tooltip = "[b][color=#c7cfcc]%s[/color][/b]\n\n" % data.name
	tooltip += "[color=#a53030]Damage[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, int(data.damage)]
	if data.multishot > 1:
		tooltip += "[color=#a53030]Multishot[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, int(data.multishot)]
	tooltip += "[color=#468232]Cooldown[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, data.cooldown*PLAYER_DATA.attackSpeed]
	tooltip += "[color=#468232]Reload[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, data.reloadSpeed]
	# Making bigger number smaller and smaller number bigger
	var bigSmallAcc = stepify((1/data.accuracy)*27, .01)
	tooltip += "[color=#7a367b]Accuracy[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, bigSmallAcc]
	if data.prefixName != "":
		tooltip += "[color=#e8c170]Prefix[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, data.prefixName]
	if data.perk:
		var perk = Node.new()
		perk.set_script(data.perk)
		tooltip += "[color=#e8c170]Perk[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, perk.PERK_NAME]
		perk.queue_free()
	
	return tooltip
