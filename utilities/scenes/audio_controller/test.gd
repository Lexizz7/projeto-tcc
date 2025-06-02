extends Area2D

func _input_event(viewport, event, shape_idx) -> void:
	if event.is_action_pressed("tap"):
		var tree = get_tree()
		if tree:
			await get_parent().play_and_wait("intro")
			get_parent().play_sound("on_mistake")
			
