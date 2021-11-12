extends Reference
class_name ToolTipGenerator


static func tooltips(data: Dictionary) -> String:
	var tooltip = ""
	
	tooltip = data.name+"\n"
	tooltip += "DMG: %s\n" % int(data.damage)
	tooltip += "Cooldown: %s\n" % data.cooldown
	tooltip += "Reload: %s\n" % data.reloadSpeed
	if data.prefixName != "":
		tooltip += "Prefix: %s\n" % data.prefixName
	if data.perk:
		var perk = Node.new()
		perk.set_script(data.perk)
		tooltip += "Perk: %s\n" % perk.PERK_NAME
		perk.queue_free()
	
	return tooltip
