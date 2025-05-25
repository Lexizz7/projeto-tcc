extends CharacterBody2D

class_name Player

signal walk_finished

enum PlayerPosition {
	LEFT,
	RIGHT
}

@export var speed := 400.0
@export var initialPosition: PlayerPosition = PlayerPosition.LEFT

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Node2D = $Sprite

var moving := false
var playerPosition: PlayerPosition

func _ready():
	face_to(initialPosition)

func face_to(position: PlayerPosition) -> void:
	playerPosition = position
	if position == PlayerPosition.LEFT:
		sprite.scale.x = abs(sprite.scale.x)
	else:
		sprite.scale.x = -abs(sprite.scale.x)

func walk_to(position: Vector2) -> void:
	if nav_agent.target_position == position:
		return
	
	if(position.x < global_position.x):
		face_to(PlayerPosition.LEFT)
	else:
		face_to(PlayerPosition.RIGHT)
	
	nav_agent.target_position = position
	moving = true
	animation_player.play("walk", -1, 2.5)
	await walk_finished
	animation_player.play("RESET")

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
