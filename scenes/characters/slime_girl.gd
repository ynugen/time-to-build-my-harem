extends CharacterBody2D
@onready var animated_sprite2d = $AnimatedSprite2D
func win():
	# perform win animation maybe? but keep bc thsi is used to detect if player has reached the end
	pass

func play():
	animated_sprite2d.play("default")
