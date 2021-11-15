extends Reference
class_name ToolTipGenerator

const DMG_COLOR = Color.red
const COLON = "[color=gray]:[/color]"



static func tooltips(data: Dictionary) -> String:
	var tooltip = ""
	
	tooltip = "[b][color=#c7cfcc]%s[/color][/b]\n\n" % data.name
	tooltip += "[color=red]DMG[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, int(data.damage)]
	if data.multishot > 1:
		tooltip += "[color=red]Multishot[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, int(data.multishot)]
	tooltip += "[color=green]Cooldown[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, data.cooldown]
	tooltip += "[color=green]Reload[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, data.reloadSpeed]
	tooltip += "[color=purple]Accuracy[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, stepify((1/data.accuracy)*27, .01)]
	if data.prefixName != "":
		tooltip += "[color=yellow]Prefix[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, data.prefixName]
	if data.perk:
		var perk = Node.new()
		perk.set_script(data.perk)
		tooltip += "[color=yellow]Perk[/color]%s [color=#c7cfcc]%s[/color]\n" % [COLON, perk.PERK_NAME]
		perk.queue_free()
	
	return tooltip
