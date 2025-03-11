extends CharacterBody2D
@onready var animated_sprite2d = $AnimatedSprite2D

var health = 20

func _ready():
	animated_sprite2d.play("default")

func attacked():
	health -= 10
	if health == 0:
		dead()

func dead():
	queue_free()
