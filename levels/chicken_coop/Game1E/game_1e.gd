extends Node2D

const CARD_FRAME = preload("res://levels/chicken_coop/Game1E/card_frame/card_frame.tscn")

@onready var card_spawn_point: Marker2D = $CardSpawnPoint
@onready var total_score_label: Label = $TotalScore
@onready var day_score_label: Label = $DayScore
@onready var night_score_label: Label = $NightScore

var day_score: int = 0:
	set(value):
		day_score = value
		day_score_label.text = str(value)
		total_score_label.text = str(value + night_score)

var night_score: int = 0:
	set(value):
		night_score = value
		night_score_label.text = str(value)
		total_score_label.text = str(value + day_score)

func _ready():
	spawn_card()

func spawn_card():
	var card_instance = CARD_FRAME.instantiate()
	card_instance.position = card_spawn_point.global_position
	add_child(card_instance)


func _on_day_box_card_frame_dropped(isCorrect: bool) -> void:
	if isCorrect:
		day_score += 1
	spawn_card()


func _on_night_box_card_frame_dropped(isCorrect: bool) -> void:
	if isCorrect:
		night_score += 1
	spawn_card()
