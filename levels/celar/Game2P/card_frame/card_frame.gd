extends Node2D

var base = 0

@onready var type: String
@onready var label: Label = $Draggable/Label
@onready var tool: Sprite2D = $Draggable/tool
@onready var tool2: Sprite2D = $Draggable/tool2
@onready var tool3: Sprite2D = $Draggable/tool3
@onready var tool4: Sprite2D = $Draggable/tool4
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
	type = animal_sprites.pick_random().name
	#label.text = type.to_upper()

func _update_animal_visibility():
	for i in animal_sprites.size():
		animal_sprites[i].visible = (i == (base % 4))
		if( base == 1):
			tool.visible = true
			tool2.visible = false
			tool3.visible = false
			tool4.visible = false
		if( base == 2):
			tool.visible = false
			tool2.visible = true
			tool3.visible = false
			tool4.visible = false
		if( base == 3):
			tool.visible = false
			tool2.visible = false
			tool3.visible = true
			tool4.visible = false
		if( base == 4):
			tool.visible = false
			tool2.visible = false
			tool3.visible = false
			tool4.visible = true

func shrink_and_free():
	var tree = get_tree()
	if !tree:
		return
	var tween := tree.create_tween()
	tween.tween_property(draggable, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	self.queue_free()
