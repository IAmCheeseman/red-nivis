extends Resource
class_name Quest

func _init(i: String, n: String, a: String, d: String) -> void:
	id = i
	name = n
	assignee = a
	description = d

var id := "quest_id"
var name := "Quest Name"
var assignee := "NPC Name"
var description := "Desc"
var counter := 0
var targetCount := 0
var completed := false
var handedIn := false

