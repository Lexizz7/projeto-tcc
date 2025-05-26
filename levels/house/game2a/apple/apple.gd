extends Node2D

@onready var animated_node: Node2D = $AnimatedNode

func _ready() -> void:
	animated_node.grow()

func _on_game_end():
	await animated_node.slide_out("bottom")
	queue_free()
