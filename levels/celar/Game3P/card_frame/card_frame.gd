extends Node2D

var base = 0

@onready var type: String
@onready var label: Label = $Draggable/Label
@onready var teste: int
@onready var animal1: Sprite2D = $Draggable/animal1
@onready var animal2: Sprite2D = $Draggable/animal2
@onready var animal3: Sprite2D = $Draggable/animal3
@onready var animal4: Sprite2D = $Draggable/animal4
@onready var animal5: Sprite2D = $Draggable/animal5
@onready var draggable: Area2D = $Draggable
@onready var image: Sprite2D = $Draggable/animal1

@onready var animal_sprites := [
	$Draggable/animal1,
	$Draggable/animal2,
	$Draggable/animal3,
	$Draggable/animal4,
	$Draggable/animal5,
]

func _ready() -> void:
	randomize() 
	
	type = ["animal"].pick_random()
	
	var max_number = 5
	var random_number = randi_range(1, max_number)

	var texture_path = "res://levels/celar/Game3P/card_frame/assets/%s_%d.png" % [type, random_number]
	
	var texture = load(texture_path)
	if texture:
		image.texture = texture
	else:
		push_error("Failed to load texture at: " + texture_path)
	
	#base = randi() % 10
	#_update_animal_visibility()
	#teste = animal_sprites.pick_random().count
	#label.text = type.to_upper()

func _update_animal_visibility():
	for i in animal_sprites.size():
		animal_sprites[i].visible = (i == (base % 5))
		if( base == 1):
			animal1.visible = true
			animal2.visible = false
			animal3.visible = false
			animal4.visible = false
			animal5.visible = false
		if( base == 2):
			animal1.visible = false
			animal2.visible = true
			animal3.visible = false
			animal4.visible = false
			animal5.visible = false
		if( base == 3):
			animal1.visible = false
			animal2.visible = false
			animal3.visible = true
			animal4.visible = false
			animal5.visible = false
		if( base == 4):
			animal1.visible = false
			animal2.visible = false
			animal3.visible = false
			animal4.visible = true
			animal5.visible = false
		if( base == 5):
			animal1.visible = false
			animal2.visible = false
			animal3.visible = false
			animal4.visible = false
			animal5.visible = true
		

func shrink_and_free():
	var tree = get_tree()
	if !tree:
		return
	var tween := tree.create_tween()
	tween.tween_property(draggable, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	self.queue_free()
