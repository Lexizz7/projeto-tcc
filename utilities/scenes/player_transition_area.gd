@tool
extends Area2D

@export var scenePath: String:
	set(value):
		scenePath = value
		if Engine.is_editor_hint():
			update_configuration_warnings()
			
@onready var player := $"../Player"

var isPlayerIn := false

func _ready() -> void:
	if !player:
		push_warning("PlayerTransitionArea must find a Player scene.")

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("tap") and player:
		await player.walk_to(global_position)
		var tree = get_tree()
		if tree and isPlayerIn and scenePath:
			tree.change_scene_to_file(scenePath)

func _on_body_entered(body: Node2D) -> void:
	if body.name != 'Player': return
	isPlayerIn = true

func _on_body_exited(body: Node2D) -> void:
	if body.name != 'Player': return
	isPlayerIn = false
	
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if !scenePath.is_absolute_path():
		return warnings.push("Must provide a scene path.")
	return warnings
