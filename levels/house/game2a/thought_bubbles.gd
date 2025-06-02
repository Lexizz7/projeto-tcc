extends Area2D
signal node_clicked(node_name: String)

func _on_thought_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("tap"):
		emit_signal("node_clicked", name)
		
func highlight_sprite():
	get_node("Red Circle").visible = true
	print("Errado")

func _on_game_game_end() -> void:
	get_node("Red Circle").visible = false
