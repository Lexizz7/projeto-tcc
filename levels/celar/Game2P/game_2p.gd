extends Node2D

const CARD_FRAME = preload("res://levels/celar/Game2P/card_frame/card_frame.tscn")

@onready var card_spawn_point: Marker2D = $CardSpawnPoint
@onready var card_stack: Area2D = $CardStack

var day_score: int = 0
var night_score: int = 0

var cards_dropped = 0

func _ready():
	spawn_card()

func spawn_card():
	if cards_dropped > 10:
		var tree = get_tree()
		if tree:
			tree.change_scene_to_file("res://levels/celar/barn.tscn")
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
	if isCorrect:
		day_score += 1
	cards_dropped += 1
	spawn_card()

func _on_night_box_card_frame_dropped(isCorrect: bool) -> void:
	if isCorrect:
		night_score += 1
	cards_dropped += 1
	spawn_card()
