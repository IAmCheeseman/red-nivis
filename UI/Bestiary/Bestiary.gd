extends Control

const ENTRY_VAR = "entry"

onready var entries = find_node("ListItems")
onready var nameLabel = find_node("Name")
onready var descLabel = find_node("Description")
onready var healthLabel = find_node("StatHealth")
onready var defenseLabel = find_node("StatDefense")
onready var enemyIcon = find_node("EnemyIcon")

var playerData = preload("res://Entities/Player/Player.tres")
var time = 0.0


func _ready() -> void:
	create_entries()


func _process(delta: float) -> void:
	enemyIcon.rect_position.y = sin(time * 2)
	time += delta


class EnemySorter:
	static func sort(a: String, b: String) -> bool:
		var al = load(a)
		var bl = load(b)
		if al.class_ == bl.class_:
			var names = [al.enemyName, bl.enemyName]
			names.sort()
			return names[1] == al.enemyName
		return al.class_ < bl.class_


func create_entries() -> void:
	Utils.free_children(entries)
	var dm := DataManager.new()

	var arrEntries = dm.list_files_in_directory("res://Entities/Enemies", true, true, "BestiaryEntry.tres")#playerData.unlockedEntries.duplicate()
	arrEntries.sort_custom(EnemySorter, "sort")
	for i in arrEntries:
		var button = CustomButton.new()
		button.text = load(i).enemyName
		button.add_font_override("font", preload("res://UI/Assets/NokiaCellphone.tres"))
		button.set_meta(ENTRY_VAR, i)
		button.align = Button.ALIGN_LEFT
		button.connect("pressed", self, "load_entry", [button])
		entries.add_child(button)


func load_entry(button: Button) -> void:
	var entry = load(button.get_meta(ENTRY_VAR))
	nameLabel.text = entry.enemyName
	descLabel.text = entry.description

	var newEnemyInst = entry.scene.instance()
	var damageManager = newEnemyInst.find_node("DamageManager")
	add_child(newEnemyInst)

	healthLabel.text = "Health: %s" % damageManager.health
	defenseLabel.text = "Defense: %s" % damageManager.defense

	var sprite = newEnemyInst.find_node("Sprite")
	var texture = AtlasTexture.new()
	texture.atlas = sprite.texture
	texture.region = Rect2(
		sprite.frame_coords,
		sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)
	)
	enemyIcon.texture = texture

	newEnemyInst.queue_free()
