extends Node2D

const FEED_BAG = preload("res://levels/celar/Game1A/feed/feed.tscn")

@onready var feed_spawn: Marker2D = $feed_spawn
@onready var animals: Array[Node2D] = [
	$Animal,
	$Animal2,
	$Animal3,
]

var total_feed = 0

func _ready() -> void:
	_setup()

func _setup():
	for animal in  animals:
		animal.randomize()
		total_feed += animal.get_to_eat()
	_spawn_feed()
		
func _spawn_feed():
	var feed_instance = FEED_BAG.instantiate()
	feed_instance.position = feed_spawn.global_position
	feed_instance.visible = true
	add_child(feed_instance)
	
	
