extends Area2D

@onready var rest_point: Vector2

var isDragging = false
var dropzone_nodes: Array[Node] = []

func _ready():
	rest_point = global_position
	dropzone_nodes = get_tree().get_nodes_in_group("dropzones")

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("tap"):
		isDragging = true
	if event.is_action_released("tap"):
		isDragging = false
		for dropzone: Area2D in dropzone_nodes:
			var overlapping_areas = dropzone.get_overlapping_areas()
			for area in overlapping_areas:
				if area.get_rid() == self.get_rid():
					dropzone.select()
					rest_point = dropzone.global_position
					return
				
			

func _physics_process(delta):
	if isDragging:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)
