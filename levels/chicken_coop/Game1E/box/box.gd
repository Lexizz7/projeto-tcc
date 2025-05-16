extends Node2D

signal card_frame_dropped

@export var type: String

func _on_dropzone_dropped(draggable: Area2D) -> void:
	var card_frame = draggable.get_parent()
	var isCorrect = type == card_frame.type
	emit_signal("card_frame_dropped", isCorrect)
	card_frame.shrink_and_free()
