extends Node2D

const APPLE = preload("res://levels/house/game2a/apple/apple.tscn")

@onready var apple_spawn_points: Node = $AppleSpawnPoints

func spawnApples(n: int):
	var markers = apple_spawn_points.get_children()
	markers.shuffle()
	markers = markers.slice(0, n)
	
	for marker in markers:
		var apple_instance = APPLE.instantiate()
		apple_instance.position = marker.global_position
		add_child(apple_instance)

func _ready():
	spawnApples(5)
