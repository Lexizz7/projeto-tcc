extends Area2D
class_name Draggable

@onready var rest_point: Vector2
@onready var initial_rest_point: Vector2

var isDragging = false
var isDisabled = false
var dropzone_nodes: Array[Node] = []
var linked_dropzone: Dropzone

func _ready():
	initial_rest_point = global_position
	reset()
	dropzone_nodes = get_tree().get_nodes_in_group("dropzones")

func reset():
	rest_point = initial_rest_point
	linked_dropzone = null

func _input_event(viewport, event, shape_idx):
	if isDisabled:
		return
	if event.is_action_pressed("tap"):
		isDragging = true
	if isDragging && event.is_action_released("tap"):
		isDragging = false
		for dropzone: Area2D in dropzone_nodes:
			var overlapping_areas = dropzone.get_overlapping_areas()
			for area in overlapping_areas:
				if area.get_rid() == self.get_rid():
					dropzone.drop(self, true)
					return
				
			

func _physics_process(delta):
	if isDragging:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)
