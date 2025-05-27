extends Node2D

const PUZZLE_PIECE = preload("res://levels/house/game3e/puzzle_piece/puzzle_piece.tscn")

@onready var dropzones: Array[Dropzone]

var pieces: Array[Draggable]

func setDropzones():
	var dropzone_nodes = self.get_tree().get_nodes_in_group("dropzones")
	
	for node in dropzone_nodes:
		if node is Dropzone:
			dropzones.push_back(node)

func spawnPieces():
	pieces = []
	for i in range(0, 3):
		var piece_instance = PUZZLE_PIECE.instantiate()
		pieces.push_back(piece_instance)
		add_child(piece_instance)
		dropzones[i].drop(piece_instance.get_child(0))

func _ready() -> void:
	setDropzones()
	spawnPieces()

func _on_dropzone_dropped(
	draggable: Draggable,
	source_dropzone: Dropzone,
	target_dropzone: Dropzone
	):
		if !source_dropzone || !target_dropzone:
			return
		
		var target_draggables: Array[Draggable] = []
		for target in target_dropzone.draggables_dropped:
			if  target.get_rid() != draggable.get_rid():
				target_draggables.push_back(target)
		
		source_dropzone.dropAll(target_draggables)
