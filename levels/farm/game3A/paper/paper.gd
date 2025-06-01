extends Node2D
@onready var draggable: Draggable = $Draggable
@onready var label: Label = $Draggable/Label

var number = 0

func shrink_and_free():
	var tween := get_tree().create_tween()
	tween.tween_property(draggable, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	self.queue_free()

func set_label(n: int):
	label.text = str(n)
	number = n
	
func get_label() -> String:
	return str(number)
