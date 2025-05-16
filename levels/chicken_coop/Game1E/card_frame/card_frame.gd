extends Node2D

@onready var type: String
@onready var label: Label = $Draggable/Label

func _ready() -> void:
	randomize() 

	type = ["day", "night"].pick_random()
	label.text = type.to_upper()
