extends Node2D

@onready var type: String
@onready var label: Label = $Draggable/Label
@onready var draggable: Area2D = $Draggable

func _ready() -> void:
	randomize() 

	type = ["day", "night"].pick_random()
	label.text = type.to_upper()

func shrink_and_free():
	var tween := get_tree().create_tween()
	tween.tween_property(draggable, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	self.queue_free()
