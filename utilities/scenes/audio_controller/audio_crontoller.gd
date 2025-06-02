extends Node2D

@onready var intro: AudioStreamPlayer2D = $intro
@onready var on_mistake: AudioStreamPlayer2D = $on_mistake
@onready var on_succeed: AudioStreamPlayer2D = $on_succeed
@onready var on_game_end: AudioStreamPlayer2D = $on_game_end
@onready var sfx: AudioStreamPlayer2D = $sfx

@export var introPath: String
@export var onMistakePath: String
@export var onSucceedPath: String
@export var onGameEndPath: String
@export var sfxPath: String

func _ready():
	if ResourceLoader.exists(introPath):
		intro.stream = load(introPath)
	if ResourceLoader.exists(onMistakePath):
		on_mistake.stream = load(onMistakePath)
	if ResourceLoader.exists(onSucceedPath):
		on_succeed.stream = load(onSucceedPath)
	if ResourceLoader.exists(onGameEndPath):
		on_game_end.stream = load(onGameEndPath)
	if ResourceLoader.exists(sfxPath):
		sfx.stream = load(sfxPath)

func _get_player_by_name(name: String) -> AudioStreamPlayer2D:
	match name:
		"intro":
			return intro
		"on_mistake":
			return on_mistake
		"on_succeed":
			return on_succeed
		"on_game_end":
			return on_game_end
		"sfx":
			return sfx
		_:
			return null

func play_and_wait(name: String) -> void:
	var player = _get_player_by_name(name)
	if player:
		player.play()
		await player.finished
	else:
		push_warning("AudioStreamPlayer2D para '" + name + "' não encontrado!")
		
func play_sound(name: String):
	var player = _get_player_by_name(name)
	if player:
		player.play()
	else:
		push_warning("AudioStreamPlayer2D para '" + name + "' não encontrado!")

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	if !introPath.is_absolute_path():
		warnings.append("Must provide a valid path for intro.")
	if !onMistakePath.is_absolute_path():
		warnings.append("Must provide a valid path for on mistake.")
	if !onSucceedPath.is_absolute_path():
		warnings.append("Must provide a valid path for on succeed.")
	if !onGameEndPath.is_absolute_path():
		warnings.append("Must provide a valid path for game end.")
	if !sfxPath.is_absolute_path():
		warnings.append("Must provide a valid path for SFX.")
	return warnings
