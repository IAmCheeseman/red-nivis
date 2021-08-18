extends Resource
class_name LootTable

export var loot:PoolStringArray = []
export var canGenerateWeapons:bool = true
export var weaponChance = .5
export(Array, float, .001, 1.0) var rarites:Array
