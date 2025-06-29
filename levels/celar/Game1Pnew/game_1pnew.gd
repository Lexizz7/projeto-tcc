extends Node2D

const CARD_FRAME = preload("res://levels/celar/Game1Pnew/card_frame/card_frame.tscn")

@onready var card_spawn_point: Marker2D = $CardSpawnPoint
@onready var card_stack: Area2D = $CardStack

var day_score: int = 0
var night_score: int = 0

var cards_dropped = 0

func _ready():
	spawn_card()

func spawn_card():
	if cards_dropped > 20:
		var tree = get_tree()
		if tree:
			tree.change_scene_to_file("res://levels/celar/barn.tscn")
		return
	
	var card_instance = CARD_FRAME.instantiate()
	card_instance.position = card_spawn_point.global_position
	card_instance.visible = false
	add_child(card_instance)
	
	card_instance.visible = true

func _on_animal1_card_frame_dropped(isCorrect: bool) -> void:
	if isCorrect:
		day_score += 1
	cards_dropped += 1
	spawn_card()

func _on_animal2_card_frame_dropped(isCorrect: bool) -> void:
	if isCorrect:
		night_score += 1
	cards_dropped += 1
	spawn_card()
func _on_animal3_card_frame_dropped(isCorrect: bool) -> void:
	if isCorrect:
		day_score += 1
	cards_dropped += 1
	spawn_card()

func _on_animal4_card_frame_dropped(isCorrect: bool) -> void:
	if isCorrect:
		night_score += 1
	cards_dropped += 1
	spawn_card()
	
func _on_animal5_card_frame_dropped(isCorrect: bool) -> void:
	if isCorrect:
		night_score += 1
	cards_dropped += 1
	spawn_card()
