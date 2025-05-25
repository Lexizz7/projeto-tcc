extends Node2D

class_name AnimatedNode2D

# Animation duration
var duration: float = 0.5
# Optional easing
var transition_type: int = Tween.TRANS_QUAD
var ease_type: int = Tween.EASE_OUT

# Store the original scale and position for reset/reference
var original_scale: Vector2
var original_position: Vector2

func _ready():
	original_scale = scale
	original_position = position

func setOriginal():
	scale = original_scale
	position = original_position

# GROW: Scale from 0 to original
func grow():
	var tween = get_tree().create_tween()
	scale = Vector2.ZERO
	tween.tween_property(self, "scale", original_scale, duration)
	await tween.finished
	
# SHRINK: Scale to 0
func shrink():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, duration)
	await tween.finished
	
# SLIDE IN from a direction
func slide_in(direction: String):
	var tween = get_tree().create_tween()
	var start_pos = original_position
	match direction:
		"left":
			position = original_position + Vector2(-get_viewport_rect().size.x, 0)
		"right":
			position = original_position + Vector2(get_viewport_rect().size.x, 0)
		"top":
			position = original_position + Vector2(0, -get_viewport_rect().size.y)
		"bottom":
			position = original_position + Vector2(0, get_viewport_rect().size.y)
		_:
			return

	tween.tween_property(self, "position", original_position, duration)
	await tween.finished

# SLIDE OUT to a direction
func slide_out(direction: String):
	var tween = get_tree().create_tween()
	var target_pos = original_position
	match direction:
		"left":
			target_pos += Vector2(-get_viewport_rect().size.x, 0)
		"right":
			target_pos += Vector2(get_viewport_rect().size.x, 0)
		"top":
			target_pos += Vector2(0, -get_viewport_rect().size.y)
		"bottom":
			target_pos += Vector2(0, get_viewport_rect().size.y)
		_:
			return

	tween.tween_property(self, "position", target_pos, duration)
	await tween.finished
