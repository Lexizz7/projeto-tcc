extends Node2D

const STAGE_COUNT := 18
const SPRITE_PATH := "res://levels/farm/Game2E/assets/items/"

@onready var item_1: Node2D = $Item1
@onready var item_2: Node2D = $Item2

var current_stage := {
	"item1": "after",
	"item2": "before",
}

var count := 0

func set_stage(index: int):
	if index < 0 or index > STAGE_COUNT:
		push_error("Stage index out of bounds")
		return {}

	var before := "%s%dbefore.png" % [SPRITE_PATH, index]
	var after := "%s%dafter.png" % [SPRITE_PATH, index]
	
	var order := randi() % 2
	
	var sprite1 = item_1.get_node("Area2D/Sprite2D")
	var sprite2 = item_2.get_node("Area2D/Sprite2D")
	
	if order == 0:
		sprite1.texture = load(before)
		sprite2.texture = load(after)
		current_stage = {
			"item1": "before",
			"item2": "after",
		}
	else:
		sprite1.texture = load(after)
		sprite2.texture = load(before)
		current_stage = {
			"item1": "after",
			"item2": "before",
		}

func _ready() -> void:
	set_stage(randi() % STAGE_COUNT)

func on_input(item: String):
	if current_stage[item] != "before":
		if item.contains('1'):
			item_1.shake()
		else:
			item_2.shake()
		return
	count += 1
	if count > 10:
		var tree = get_tree()
		if tree:
			tree.change_scene_to_file("res://levels/farm/farm.tscn")
		return
	
	item_1.shrink()
	await item_2.shrink()
	set_stage(randi() % STAGE_COUNT)
	
	item_1.grow()
	item_2.grow()

func _on_item_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("tap"):
		on_input("item1")


func _on_item_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("tap"):
		on_input("item2")
