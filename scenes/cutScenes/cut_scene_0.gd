extends Node2D

# Define animation player variable
@onready var animPlayer = $AnimationPlayer
var first_time = false

func _ready():
	animPlayer.play("StartScene")
	animPlayer.connect("animation_finished", _on_animation_finished)

# Skips cut scene if space or enter is pressed
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		skip_cutscene()

func _on_animation_finished(animName):
	skip_cutscene()

# Change to level scene
func skip_cutscene():
	get_tree().change_scene_to_file("res://scenes/levels/Level0.tscn")
