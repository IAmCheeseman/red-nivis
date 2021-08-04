extends Resource
class_name Minibiome

export(float, 0, 1) var rarity = .25
export var maxTileSpace:int = 32
export var minTileSpace:int = 16
export var maxSize:Vector2 = Vector2(32, 32)
export var minSize:Vector2 = Vector2(16, 16)
export(int,
"Sky",
"Surface",
"Underground",
"Caverns") var generationLayer = 2
export var generationScript:Script
export var tilesColor:Color = Color.cyan
export var bgColor:Color = Color.darkcyan
export var mainTiles : PackedScene
export var bgTiles : PackedScene
export(Array, PackedScene) var ruins
export(Array, PackedScene) var enemies
export(Array, float) var enemyChances
export(Array, PackedScene) var props
