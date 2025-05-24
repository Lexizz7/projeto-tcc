extends Node2D
signal feed_droped

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
	feed_consumed = 0
	
func _update_animal_visibility():
	for i in animal_sprites.size():
		animal_sprites[i].visible = (i == (base % 3))
		
func get_to_eat() -> int:
	return to_eat

func is_fed():
	return feed_consumed == to_eat

func _on_dropzone_dropped(draggable: Area2D) -> void:
	var feed_bag = draggable.get_parent()
	feed_consumed += 1
	emit_signal("feed_droped")
	feed_bag.shrink_and_free()
