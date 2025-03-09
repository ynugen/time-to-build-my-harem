extends Node2D

# Define animation player variable
@onready var animPlayer = $AnimationPlayer
var first_time = false

func _ready():
	animPlayer.play("StartScene")
	animPlayer.connect("animation_finished", _on_animation_finished)

# Skips cut scene if space or enter is pressed
func _process(delta):
	if first_time && Input.is_action_pressed("ui_accept"):
		skip_cutscene()

# Change to level when animation finished
func _on_animation_finished(animName):
	first_time = true
	skip_cutscene()

# Change to level scene
func skip_cutscene():
	get_tree().change_scene_to_file("res://scenes/levels/Level0.tscn")

# Skip cutscene if skip button pressed
func _on_skip_pressed() -> void:
	skip_cutscene()
