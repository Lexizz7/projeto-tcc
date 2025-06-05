extends Node2D

@onready var type: String
@onready var draggable: Area2D = $Draggable
@onready var image: Sprite2D = $Draggable/Image

func _ready() -> void:
	randomize() 
	
	type = ["tool"].pick_random()
	
	var max_number = 4
	var random_number = randi_range(1, max_number)

	var texture_path = "res://levels/celar/Game2Pnew/card_frame/assets/%s_%d.png" % [type, random_number]
	
	var texture = load(texture_path)
	if texture:
		image.texture = texture
	else:
		push_error("Failed to load texture at: " + texture_path)
	

func shrink_and_free():
	var tree = get_tree()
	if !tree:
		return
	var tween := tree.create_tween()
	tween.tween_property(draggable, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	self.queue_free()
