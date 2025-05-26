extends Node2D

const APPLE = preload("res://levels/house/game2a/apple/apple.tscn")

@onready var apple_spawn_points: Node = $AppleSpawnPoints
@onready var thought_baloons := [
	$thought_1/Label,
	$thought_2/Label,
	$thought_3/Label
]

var answer = 0

func spawnApples(n: int):
	answer = n
	var markers = apple_spawn_points.get_children()
	markers.shuffle()
	markers = markers.slice(0, n)
	
	for marker in markers:
		var apple_instance = APPLE.instantiate()
		apple_instance.position = marker.global_position
		add_child(apple_instance)
		
func _randomize():
	thought_baloons.shuffle()
	var numbers = _number_generator(6)
	spawnApples(numbers[0] + 5)
	for i in range (0, 3):
		thought_baloons[i].text = str(numbers[i] + 5)
		
func _number_generator(n: int):
	var numbers = []
	for i in range(1, n):
		numbers.append(i)
	numbers.shuffle()
	return numbers.slice(0, 3)


func _ready():
	_randomize()
