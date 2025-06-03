extends Node2D

var base = 0

@onready var type: String
@onready var label: Label = $Draggable/Label
@onready var draggable: Area2D = $Draggable

@onready var animal_sprites := [
	$Draggable/tool,
	$Draggable/tool2,
	$Draggable/tool3,
	$Draggable/tool4,
]

func _ready() -> void:
	randomize() 
	base = randi() % 10
	_update_animal_visibility()
	#type = [animals_sprites[1], animals_sprites[2]].pick_random()
	#label.text = type.to_upper()

func _update_animal_visibility():
	for i in animal_sprites.size():
		animal_sprites[i].visible = (i == (base % 4))

func shrink_and_free():
	var tree = get_tree()
	if !tree:
		return
	var tween := tree.create_tween()
	tween.tween_property(draggable, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	self.queue_free()
