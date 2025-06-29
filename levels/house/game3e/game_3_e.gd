extends Node2D

const PUZZLE_PIECE = preload("res://levels/house/game3e/puzzle_piece/puzzle_piece.tscn")

@onready var audio_crontoller: Node2D = $AudioCrontoller
@onready var dropzones: Array[Dropzone]

var pieces: Array[PuzzlePiece]
var games := [1,2,3,4,5,6]

func setDropzones():
	var dropzone_nodes = self.get_tree().get_nodes_in_group("dropzones")
	for node in dropzone_nodes:
		if node is Dropzone:
			dropzones.push_back(node)

func spawnPieces():
	for child in pieces:
		child.queue_free()
	pieces.clear()

	if games.is_empty():
		var tree = get_tree()
		if tree:
			await audio_crontoller.play_and_wait("on_game_end")
			tree.change_scene_to_file("res://levels/house/house.tscn")
			MetricsLogger.end_session()
		return
	
	var game = games.pick_random()
	games = games.filter(
		func(g):
			return g != game
	)
	
	for i in range(0, dropzones.size()):
		var piece_instance = PUZZLE_PIECE.instantiate()
		var texture_path = "res://levels/house/game3e/puzzle_piece/assets/game_%d_%d.png" % [game,  i + 1]
		piece_instance.index = i
		pieces.append(piece_instance)
		add_child(piece_instance)
		piece_instance.setItem(texture_path)
	
	var is_order_correct := true
	while is_order_correct:
		pieces.shuffle()
		for i in range(pieces.size()):
			if pieces[i].index != i:
				is_order_correct = false
				break
	
	for i in range(dropzones.size()):
		dropzones[i].drop(pieces[i].get_child(0))
		
func disablePieces():
	for piece in pieces:
		piece.get_child(0).isDisabled = true

func _ready() -> void:
	await audio_crontoller.play_and_wait("intro")
	MetricsLogger.start_session("Game3E")
	setDropzones()
	spawnPieces()

func _on_dropzone_dropped(
	draggable: Draggable,
	source_dropzone: Dropzone,
	target_dropzone: Dropzone
) -> void:
	if !source_dropzone or !target_dropzone:
		return

	var target_draggables: Array[Draggable] = []
	for target in target_dropzone.draggables_dropped:
		if target && (target.get_rid() != draggable.get_rid()):
			target_draggables.append(target)

	source_dropzone.dropAll(target_draggables)

	if _is_puzzle_completed():
		MetricsLogger.log_event("PieceMoved", {
			"isCorrect": true,
		})
		disablePieces()
		await get_tree().create_timer(0.5).timeout
		spawnPieces()
	else:
		MetricsLogger.log_event("PieceMoved", {
			"isCorrect": false,
		})

func _is_puzzle_completed() -> bool:
	for i in range(dropzones.size()):
		if dropzones[i].draggables_dropped.size() == 0:
			return false
		var dropped_piece = dropzones[i].draggables_dropped[0]
		if dropped_piece && dropped_piece.get_parent().index != i:
			return false
	return true
