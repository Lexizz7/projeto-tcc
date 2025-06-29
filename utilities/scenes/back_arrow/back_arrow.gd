@tool
extends Area2D

@export var scenePath: String:
	set(value):
		scenePath = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

func _input_event(viewport, event, shape_idx) -> void:
	if event.is_action_pressed("tap"):
		var tree = get_tree()
		if tree and scenePath:
			tree.change_scene_to_file(scenePath)
			MetricsLogger.end_session()

func _get_configuration_warnings() -> PackedStringArray:
	if !scenePath.is_absolute_path():
		return ["Must provide a scene path."]
	return []
