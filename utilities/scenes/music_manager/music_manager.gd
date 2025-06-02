extends Node2D
@onready var background_music: AudioStreamPlayer2D = $Background_Music

func _ready() -> void:
	if background_music == null:
		push_error("bg_song é NULL!")
	else:
		background_music.play()
