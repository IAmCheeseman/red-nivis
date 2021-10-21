extends CanvasLayer


onready var viewport = $VPC/Viewport


func _ready() -> void:
	get_tree().connect("node_added", self, "_on_node_added")


func _on_node_added(node:Node):
	if node is Particles2D or node is CPUParticles2D:
		node.get_parent().remove_child(node)
		viewport.add_child(node)
