extends Node2D

const CARD_FRAME = preload("res://levels/celar/Game2Pnew/card_frame/card_frame.tscn")

@onready var card_spawn_point: Marker2D = $CardSpawnPoint
@onready var card_stack: Area2D = $CardStack
@onready var results_tracker: ResultTracker = $ResultsTracker

var f1: int = 0
var f2: int = 0
var f3: int = 0
var f4: int = 0

var cards_dropped = 0

func _ready():
	MetricsLogger.start_session("Game2P")
	spawn_card()

func spawn_card():
	if cards_dropped > 20:
		var tree = get_tree()
		if tree:
			tree.change_scene_to_file("res://levels/celar/barn.tscn")
		MetricsLogger.end_session()
		return
	
	var card_instance = CARD_FRAME.instantiate()
	card_instance.position = card_spawn_point.global_position
	card_instance.visible = false
	add_child(card_instance)
	
	card_instance.visible = true

func _on_tool1_card_frame_dropped(isCorrect: bool) -> void:
	MetricsLogger.log_event("F1Dropped", {
		"isCorrect": isCorrect
	})
	if isCorrect:
		results_tracker.add_hit()
		f1 += 1
	else:
		results_tracker.add_miss()
	cards_dropped += 1
	spawn_card()

func _on_tool2_card_frame_dropped(isCorrect: bool) -> void:
	MetricsLogger.log_event("F2Dropped", {
		"isCorrect": isCorrect
	})
	if isCorrect:
		results_tracker.add_hit()
		f2 += 1
	else:
		results_tracker.add_miss()
	cards_dropped += 1
	spawn_card()
	
func _on_tool3_card_frame_dropped(isCorrect: bool) -> void:
	MetricsLogger.log_event("F3Dropped", {
		"isCorrect": isCorrect
	})
	if isCorrect:
		results_tracker.add_hit()
		f3 += 1
	else:
		results_tracker.add_miss()
	cards_dropped += 1
	spawn_card()
	
func _on_tool4_card_frame_dropped(isCorrect: bool) -> void:
	MetricsLogger.log_event("F4Dropped", {
		"isCorrect": isCorrect
	})
	if isCorrect:
		results_tracker.add_hit()
		f4 += 1
	else:
		results_tracker.add_miss()
	cards_dropped += 1
	spawn_card()
