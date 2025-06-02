extends Node2D
class_name PuzzlePiece

@onready var draggable: Draggable = $Draggable
@onready var sprite_2d: Sprite2D = $Draggable/Sprite2D
@onready var item: Sprite2D = $Draggable/Item

var index: int

func _ready():
	randomize()
	sprite_2d.self_modulate = get_random_cool_color()

func setItem(str):
	var texture = load(str)
	if texture:
		item.texture = texture

func get_random_cool_color() -> Color:
	var hue = randf_range(0, 1)
	var saturation = randf_range(0.4, 0.6)
	var value = 1.0
	return Color.from_hsv(hue, saturation, value)

func swapPiece(sourceDropzone: Dropzone, targetDropzone: Dropzone):
	if targetDropzone.draggable_dropped:
		targetDropzone.draggable_dropped.dropTo(sourceDropzone)
		
	draggable.dropTo(sourceDropzone)
