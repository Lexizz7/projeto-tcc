extends Node2D

signal game_end
signal paper_droped(answer: bool, number:String)
const SHEEP = preload("res://levels/farm/game3A/sheep/sheep.tscn")

@onready var red_circle: Sprite2D = $"red circle"
@onready var sheep_spawn: Node = $sheep_spawn

var total_sheep = 0

func spawn_sheep(n: int, color: String):
	total_sheep = 0
	var markers = sheep_spawn.get_children().slice(0, n)
	for marker in markers:
		var sheep_instance = SHEEP.instantiate()
		sheep_instance.position = marker.global_position
		connect("game_end", Callable(sheep_instance, "_on_game_end"))
		add_child(sheep_instance)
		total_sheep += 1
		sheep_instance.set_color(color)
		

func _on_dropzone_dropped(draggable: Draggable) -> void:
	red_circle.visible = false
	var paper_instance = draggable.get_parent()
	print(paper_instance.get_label())
	print(total_sheep)
	await paper_instance.shrink_and_free()
	emit_signal("paper_droped", paper_instance.get_label() == str(total_sheep), paper_instance.get_label())

func get_total_sheep():
	return str(total_sheep)
	
func show_answer():
	red_circle.visible = true

func _on_game_end() -> void:
	emit_signal("game_end")
