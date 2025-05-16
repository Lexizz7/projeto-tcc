extends Area2D

signal dropped

func drop(draggable: Area2D):
	var tree = get_tree()
	if !tree: 
		return
	
	for child in tree.get_nodes_in_group("dropzones"):
		child.undrop()
	
	emit_signal("dropped", draggable)

func undrop():
	pass
