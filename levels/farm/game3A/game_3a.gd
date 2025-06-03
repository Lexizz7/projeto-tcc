extends Node2D
signal game_end
const PAPER = preload("res://levels/farm/game3A/paper/paper.tscn")
@onready var audio_crontoller: Node2D = $AudioCrontoller
@onready var number_spawn: Marker2D = $number_spawn
@onready var horde: Node = $horde

var score = 0
var round = 0
var is_correct = true
var number_list = []
var colors := [
		"blue",
		"green",
		"orange",
		"red",
		"white"
	]
	
func _ready() -> void:
	score = 0
	round = 0
	await audio_crontoller.play_and_wait("intro")
	_randomize()

func _randomize():
	
	if round >= 1:
		_game_finish()
		return
	round += 1
	var hordes = horde.get_children()
	number_list = _number_generator(9)
	colors.shuffle()
	for i in hordes.size():
		hordes[i].spawn_sheep(number_list[i], colors[i])
	number_list.shuffle()
	print(number_list)
	spawn_paper(number_list.pop_front())
		
func spawn_paper(n: int):
	var paper_instance = PAPER.instantiate()
	paper_instance.global_position = number_spawn.global_position
	add_child(paper_instance)
	paper_instance.set_label(n)

func _on_sheep_horde_paper_droped(answer: bool, number: String) -> void:
	print("papel")
	if number_list.size() == 0:
		validate()
		_randomize()
		return
	if !answer:
		is_correct = false
		for group in horde.get_children():
			if group.get_total_sheep() == number:
				group.show_answer()
		number_list.push_front(int(number))
	print(is_correct)
	spawn_paper(number_list.pop_front())

func validate():
	if is_correct:
		score += 1
	is_correct = true
	emit_signal("game_end")
	
func _number_generator(n: int):
	var numbers = []
	for i in range(1, n):
		numbers.append(i)
	numbers.shuffle()
	return numbers.slice(0, 5)
	
func _game_finish():
	await audio_crontoller.play_and_wait("on_game_end")
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://levels/farm/farm.tscn")
