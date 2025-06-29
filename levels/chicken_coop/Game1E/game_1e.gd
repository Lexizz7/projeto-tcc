extends Node2D

const CARD_FRAME = preload("res://levels/chicken_coop/Game1E/card_frame/card_frame.tscn")

@onready var card_spawn_point: Marker2D = $CardSpawnPoint
@onready var card_stack: Area2D = $CardStack
@onready var audio_crontoller: Node2D = $AudioCrontoller
@onready var results_tracker: ResultTracker = $ResultsTracker
@onready var red_circles: Node = $RedCircles

var day_score: int = 0
var night_score: int = 0

var cards_dropped = 0

func _ready():
	await audio_crontoller.play_and_wait("intro")
	MetricsLogger.start_session("Game1E")
	spawn_card()

func spawn_card():
	if cards_dropped > 10:
		card_stack.level = 4
		var tree = get_tree()
		if tree:
			await audio_crontoller.play_and_wait("on_game_end")
			tree.change_scene_to_file("res://levels/chicken_coop/chicken_coop.tscn")
		MetricsLogger.end_session()
		return
	elif  cards_dropped > 7:
		card_stack.level = 3
	elif cards_dropped > 4:
		card_stack.level = 2
	else:
		card_stack.level = 1
	
	var card_instance = CARD_FRAME.instantiate()
	card_instance.position = card_spawn_point.global_position
	card_instance.visible = false
	add_child(card_instance)
	
	card_instance.position = card_stack.global_position
	card_instance.visible = true

func _on_day_box_card_frame_dropped(isCorrect: bool) -> void:
	MetricsLogger.log_event("DayBoxDropped", {
		"isCorrect": isCorrect
	})
	_hide_all_circles()
	if isCorrect:
		results_tracker.add_hit()
		day_score += 1
		cards_dropped += 1
		spawn_card()
	else:
		_show_circle(1)
		results_tracker.add_miss()

func _on_night_box_card_frame_dropped(isCorrect: bool) -> void:
	MetricsLogger.log_event("NightBoxDropped", {
		"isCorrect": isCorrect
	})
	_hide_all_circles()
	if isCorrect:
		results_tracker.add_hit()
		night_score += 1
		cards_dropped += 1
		spawn_card()
	else:
		_show_circle(0)
		results_tracker.add_miss()

func _hide_all_circles():
	for node in red_circles.get_children():
		if !node:
			continue
		node.hide()

func _show_circle(index: int):
	var circle = red_circles.get_children()[index]
	if !circle:
		return
	circle.show()
