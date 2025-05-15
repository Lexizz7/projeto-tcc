extends Area2D

@onready var player := $"../Player"

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		await player.walk_to(global_position)
		get_tree().change_scene_to_file("res://levels/chicken_coop/chicken_coop.tscn")
