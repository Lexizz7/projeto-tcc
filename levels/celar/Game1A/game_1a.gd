extends Node2D

const FEED_BAG = preload("res://levels/celar/Game1A/feed/feed.tscn")

@onready var feed_left: Label = $feed_left
@onready var feed_spawn: Marker2D = $feed_spawn
@onready var animals: Array[Node2D] = [
	$Animal,
	$Animal2,
	$Animal3,
]
@onready var feed_animation_mark: Marker2D = $feed_animation_mark

var total_feed = 0
var score = 0
var round = 0

func _ready() -> void:
	score = 0
	round = 0
	_setup()

func _setup():
	if round >= 10:
		_game_finish()
	round += 1
	total_feed = 0
	for animal in  animals:
		animal.randomize()
		total_feed += animal.get_to_eat()
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
		score += 1
	_setup()


func _on_animal_overfed() -> void:
	print("Overfed")
	total_feed += 1
	feed_left.text = str(total_feed)
	for animal in animals:
		animal.on_overfed()

func _game_finish():
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://levels/celar/barn.tscn")
