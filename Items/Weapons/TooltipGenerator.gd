extends Reference
class_name ToolTipGenerator

#const COLON = "[color=#a8b5b2]:[/color]"

const PLAYER_DATA = preload("res://Entities/Player/Player.tres")

enum TIERS {LAB, CAVE, DEEPLABS, FREEZERS, TOXIC_CAVERNS, TECH_LABS}

const TIER_COLORS = {
	TIERS.LAB           : "#c7cfcc",
	TIERS.CAVE          : "#75a743",
	TIERS.DEEPLABS      : "#a53030",
	TIERS.FREEZERS      : "#ffffff",
	TIERS.TOXIC_CAVERNS : "#468232",
}


static func tooltips(name: String, tier: int) -> String:
	var tooltip = ""
	tooltip = "[color=%s]%s[/color]" % [TIER_COLORS[tier], name]
	
	return tooltip
