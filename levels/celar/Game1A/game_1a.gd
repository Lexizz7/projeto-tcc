extends Node2D

const FEED_BAG = preload("res://levels/celar/Game1A/feed/feed.tscn")
@onready var audio_crontoller: Node2D = $AudioCrontoller
@onready var feed_left: Label = $feed_left
@onready var feed_spawn: Marker2D = $feed_spawn
@onready var animals: Array[Node2D] = [
	$Animal,
	$Animal2,
	$Animal3,
]
@onready var feed_animation_mark: Marker2D = $feed_animation_mark
@onready var results_tracker: ResultTracker = $ResultsTracker

var total_feed = 0
var score = 0
var round = 0
var on_enter = true

func _ready() -> void:
	MetricsLogger.start_session("Game1A")
	on_enter = true
	score = 0
	round = 0
	_setup()
	

func _setup():
	if round >= 5:
		_game_finish()
		return
	round += 1
	total_feed = 0
	for animal in  animals:
		animal.randomize()
		total_feed += animal.get_to_eat()
	if on_enter:
		on_enter = false
		await audio_crontoller.play_and_wait("intro")
	_spawn_feed()

func _spawn_feed():
	var feed_instance = FEED_BAG.instantiate()
	feed_instance.position = feed_spawn.global_position
	feed_instance.hide()
	add_child(feed_instance)
	
	feed_instance.position = feed_animation_mark.global_position
	feed_instance.show()
	
	feed_left.text = str(total_feed)

func _on_animal_feed_droped() -> void:
	total_feed -= 1
	if total_feed == 0:
		_verify()
		return
	_spawn_feed()

func _verify():
	var is_correct: bool
	for animal in  animals:
		is_correct = animal.is_fed()
	if is_correct:
		results_tracker.add_hit()
		MetricsLogger.log_event("AnimalsFed", {
			"isCorrect": true,
		})
	_setup()


func _on_animal_overfed() -> void:
	print("Overfed")
	results_tracker.add_miss()
	MetricsLogger.log_event("AnimalOverfed", {
			"isCorrect": false,
		})
	total_feed += 1
	feed_left.text = str(total_feed)
	for animal in animals:
		animal.on_overfed()

func _game_finish():
	MetricsLogger.end_session()
	await audio_crontoller.play_and_wait("on_game_end")
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://levels/celar/barn.tscn")
