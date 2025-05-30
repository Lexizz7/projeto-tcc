extends Node2D

@onready var draggable: Area2D = $Draggable

func shrink_and_free():
	var tween := get_tree().create_tween()
	tween.tween_property(draggable, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	self.queue_free()
