extends Area2D

@export_range(1, 4) var level: int = 1:
	set(value):
		level = clamp(value, 1, 4)
		_update_level_visibility()

@onready var level_sprites := [
	$level1,
	$level2,
	$level3,
	$level4
]

func _ready():
	_update_level_visibility()

func _update_level_visibility():
	for i in level_sprites.size():
		level_sprites[i].visible = (i == level - 1)
