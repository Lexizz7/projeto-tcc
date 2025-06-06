extends Node2D

signal card_frame_dropped

@export var type: String

func _on_dropzone_dropped(draggable: Draggable) -> void:
	var card_frame = draggable.get_parent()
	var isCorrect = type == card_frame.type
	emit_signal("card_frame_dropped", isCorrect)
	if isCorrect:
		card_frame.shrink_and_free()
	else:
		draggable.linked_dropzone.undrop(draggable)
