extends Area2D
class_name Dropzone

signal dropped

var draggables_dropped: Array[Draggable]

func drop(draggable: Draggable, emitSignals: bool = false):	
	var source_dropzone = draggable.linked_dropzone
	if source_dropzone:
		source_dropzone.undrop(draggable)
	
	draggable.rest_point = global_position
	draggable.linked_dropzone = self
	
	draggables_dropped.push_back(draggable)
	
	if emitSignals:
		emit_signal("dropped", draggable, source_dropzone, self)
		emit_signal("dropped", draggable)

func undrop(draggable: Draggable):
	draggables_dropped = draggables_dropped.filter(
		func(item):
			if !item:
				return
			return item.get_rid() != draggable.get_rid()
	)
	draggable.reset()

func undropAll():
	for draggable in draggables_dropped:
		undrop(draggable)

func dropAll(draggables: Array[Draggable]):
	draggables_dropped = []
	for draggable in draggables:
		drop(draggable)
