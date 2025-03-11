extends StaticBody2D

@export var push_distance = 250
@onready var anim_player = $AnimationPlayer

func push(direction: Vector2):
	global_position += direction * push_distance

func push_deline():
	anim_player.play("push_declined")
