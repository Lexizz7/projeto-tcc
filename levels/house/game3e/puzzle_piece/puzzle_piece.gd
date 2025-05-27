extends Node2D

@onready var draggable: Draggable = $Draggable

func swapPiece(sourceDropzone: Dropzone, targetDropzone: Dropzone):
	if targetDropzone.draggable_dropped:
		targetDropzone.draggable_dropped.dropTo(sourceDropzone)
		
	draggable.dropTo(sourceDropzone)
