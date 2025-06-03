extends Area2D

@export_range(1, 3) var level: int = 1:
	set(value):
		level = clamp(value, 1, 3)
		_update_level_visibility()

@onready var level_sprites := [
	$level1,
	$level2,
	$level3,
]

func _ready():
	_update_level_visibility()

func _update_level_visibility():
	for i in level_sprites.size():
		level_sprites[i].visible = (i == level - 1)
