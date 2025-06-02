extends Node2D
signal feed_droped
signal overfed

var base = 0
var to_eat = 0
var feed_consumed = 0
var revealed = false

@onready var red_circle: Sprite2D = $Dropzone/red_circle
@onready var label: Label = $Label
@onready var animal_sprites := [
	$Dropzone/sheep,
	$Dropzone/cow,
	$Dropzone/horse,
]

func randomize():
	revealed = false
	base = randi() % 10
	_update_animal_visibility()
	to_eat = ((base - 1) / 3) + 1
	print(to_eat)
	label.text = str(to_eat)
	feed_consumed = 0
	
func _update_animal_visibility():
	red_circle.visible = false
	for i in animal_sprites.size():
		animal_sprites[i].visible = (i == (base % 3))
		
func get_to_eat() -> int:
	return to_eat

func is_fed():
	return feed_consumed == to_eat

func _on_dropzone_dropped(draggable: Area2D) -> void:
	var feed_bag = draggable.get_parent()
	if feed_consumed >= to_eat:
		emit_signal("overfed")
		feed_consumed -= 1
	await feed_bag.shrink_and_free()
	feed_consumed += 1
	if revealed:
		show_answer()
	print(name + ": " + str(feed_consumed))
	emit_signal("feed_droped")
	
func show_answer():
	label.text = str(feed_consumed) + "/" + str(to_eat)
	

func on_overfed() -> void:
	show_answer()
	revealed = true
	if feed_consumed < to_eat:
		red_circle.visible = true
		return
	red_circle.visible = false
