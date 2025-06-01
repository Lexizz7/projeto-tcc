extends Node2D

@onready var animated_node: Node2D = $AnimatedNode
@onready var sheep_sprites:= [
	$AnimatedNode/white,
	$AnimatedNode/red,
	$AnimatedNode/orange,
	$AnimatedNode/green,
	$AnimatedNode/blue
	]

func _ready() -> void:
	animated_node.grow()

func set_color(color: String):
	for i in sheep_sprites.size():
		var sprite = sheep_sprites[i]
		sprite.visible = (sprite.name == color)
	
func _on_game_end():
	queue_free()
