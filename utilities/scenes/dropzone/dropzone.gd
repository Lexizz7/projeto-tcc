extends Area2D

signal selected

func select():
	var tree = get_tree()
	if !tree: 
		return
	
	for child in tree.get_nodes_in_group("dropzones"):
		child.deselect()
	
	emit_signal("selected")

func deselect():
	pass
