extends Area2D

@onready var player := $"../Player"

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		player.walk_to(global_position)
