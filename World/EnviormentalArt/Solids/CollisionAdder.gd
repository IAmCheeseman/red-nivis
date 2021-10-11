tool
extends TileMap

export var counter :=  0
export var generateColliosions := false setget dothing

var tileSize = 16
var spriteSheetSize = Vector2(11, 10)

func _ready() -> void:
	if Engine.editor_hint:
		generate_collisions()

func generate_collisions() -> void:
	for x in spriteSheetSize.x:
		for y in spriteSheetSize.y:
			var shape = ConvexPolygonShape2D.new()
			shape.points = [Vector2.ZERO, Vector2(0, tileSize), Vector2(tileSize, tileSize), Vector2(tileSize, 0)]
			tile_set.tile_add_shape(0,
									shape,
									Transform2D(0, Vector2.ZERO),
									false,
									Vector2(x, y))

func dothing(val) -> void:
	generate_collisions()
