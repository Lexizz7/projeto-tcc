extends Node2D

const STAGE_COUNT := 18
const SPRITE_PATH := "res://levels/farm/Game2E/assets/items/"

@onready var item_1: Node2D = $Item1
@onready var item_2: Node2D = $Item2
@onready var audio_crontoller: Node2D = $AudioCrontoller
@onready var results_tracker: ResultTracker = $ResultsTracker
@onready var red_circles: Node = $RedCircles

var current_stage := {
	"item1": "after",
	"item2": "before",
}

var count := 0
var disable_input := false

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
	await audio_crontoller.play_and_wait("intro")
	MetricsLogger.start_session("Game2E")
	set_stage(randi() % STAGE_COUNT)

func on_input(item: String):
	_hide_all_circles()
	if current_stage[item] != "before":
		MetricsLogger.log_event("%s tapped" % item, {
			"isCorrect": false,
		})
		results_tracker.add_miss()
		if item.contains('1'):
			item_1.shake()
			_show_circle(1)
		else:
			item_2.shake()
			_show_circle(0)
		return
		
	MetricsLogger.log_event("%s tapped" % item, {
		"isCorrect": true,
	})
	results_tracker.add_hit()
		
	count += 1
	if count > 10:
		var tree = get_tree()
		if tree:
			await audio_crontoller.play_and_wait("on_game_end")
			tree.change_scene_to_file("res://levels/farm/farm.tscn")
			MetricsLogger.end_session()
		return
	
	item_1.shrink()
	await item_2.shrink()
	set_stage(randi() % STAGE_COUNT)
	
	item_1.grow()
	await item_2.grow()

func _on_item_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if disable_input:
		return
	if event.is_action_pressed("tap"):
		disable_input = true
		await on_input("item1")
		disable_input = false


func _on_item_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if disable_input:
		return
	if event.is_action_pressed("tap"):
		disable_input = true
		await on_input("item2")
		disable_input = false

func _hide_all_circles():
	for node in red_circles.get_children():
		if !node:
			continue
		node.hide()

func _show_circle(index: int):
	var circle = red_circles.get_children()[index]
	if !circle:
		return
	circle.show()
