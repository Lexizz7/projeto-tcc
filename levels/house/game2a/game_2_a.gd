extends Node2D

const APPLE = preload("res://levels/house/game2a/apple/apple.tscn")
signal game_end()
@onready var apple_spawn_points: Node = $AppleSpawnPoints
@onready var thought_baloons: Array[Node2D]= [
	$thought_1,
	$thought_2,
	$thought_3,
]
@onready var audio_crontoller: Node2D = $AudioCrontoller

var answer = 0
var score = 0
var round = 0
var is_correct = 1

func spawnApples(n: int):
	answer = n
	var markers = apple_spawn_points.get_children()
	markers.shuffle()
	markers = markers.slice(0, n)
	
	for marker in markers:
		var apple_instance = APPLE.instantiate()
		apple_instance.position = marker.global_position
		connect("game_end", Callable(apple_instance, "_on_game_end"))
		add_child(apple_instance)
		
func _randomize():
	if round >= 20:
		_game_finish()
		return
	round += 1
	is_correct = 1
	thought_baloons.shuffle()
	var numbers = _number_generator(5)
	spawnApples(numbers[0] + 5)
	for i in range (0, 3):
		thought_baloons[i].get_node("Label").text = str(numbers[i] + 5)
		
func _number_generator(n: int):
	var numbers = []
	for i in range(1, n):
		numbers.append(i)
	numbers.shuffle()
	return numbers.slice(0, 3)

func _ready():
	await audio_crontoller.play_and_wait("intro")
	_randomize()


func _on_thought_node_clicked(node_name: String) -> void:
	if get_node(node_name).get_node("Label").text == str(answer):
		score += is_correct
		emit_signal("game_end")
		_randomize()
		return
	thought_baloons[0].highlight_sprite()
	is_correct = 0
	
func _game_finish():
	await audio_crontoller.play_and_wait("on_game_end")
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://levels/house/house.tscn")
