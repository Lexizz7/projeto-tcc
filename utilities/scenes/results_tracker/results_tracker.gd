extends Node

class_name ResultTracker

@onready var label: Label = $Label

var result: String = ""
var has_error: bool = false

func add_hit():
	if has_error:
		has_error = false
		return
	result += "O "
	_update_label()

func add_miss():
	if has_error:
		return
	result += "X "
	has_error = true
	_update_label()

func get_result() -> String:
	return result.strip_edges()

func _update_label():
	label.text = get_result()
