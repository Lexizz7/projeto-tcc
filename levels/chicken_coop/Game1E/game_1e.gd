extends Node2D

const CARD_FRAME = preload("res://levels/chicken_coop/Game1E/card_frame/card_frame.tscn")

@onready var card_spawn_point: Marker2D = $CardSpawnPoint

func _ready():
	spawn_card()

func spawn_card():
	var card_instance = CARD_FRAME.instantiate()
	card_instance.position = card_spawn_point.global_position
	add_child(card_instance)
