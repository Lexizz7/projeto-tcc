extends CharacterBody2D

signal walk_finished

@export var speed := 400.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var moving := false

func walk_to(position: Vector2) -> void:
	nav_agent.target_position = position
	moving = true
	await self.walk_finished

func _physics_process(delta: float) -> void:
	if moving:
		if nav_agent.is_navigation_finished():
			velocity = Vector2.ZERO
			moving = false
			emit_signal("walk_finished")
			return

		var next_path_point = nav_agent.get_next_path_position()
		var direction = (next_path_point - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
