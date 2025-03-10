extends StaticBody2D

@export var push_distance = 250

func push(direction: Vector2):
	global_position += direction * push_distance
