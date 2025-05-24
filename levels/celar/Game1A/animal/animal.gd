extends Node2D

var base = 0
var to_eat = 0
var feed_consumed = 0

@onready var label: Label = $Label
@onready var animal_sprites := [
	$Dropzone/sheep,
	$Dropzone/cow,
	$Dropzone/horse,
]

func randomize():
	base = randi() % 10
	_update_animal_visibility()
	to_eat = ((base - 1) / 3) + 1
	print(to_eat)
	label.text = str(to_eat)
	
func _update_animal_visibility():
	for i in animal_sprites.size():
		animal_sprites[i].visible = (i == (base % 3))
		
func get_to_eat() -> int:
	return to_eat
