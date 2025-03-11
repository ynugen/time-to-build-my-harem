extends Node2D

@onready var animPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("MeetCute")


func _on_success_choice_pressed() -> void:
	animPlayer.play("Success")


func _on_fail_choice_pressed() -> void:
	animPlayer.play("Fumble")


func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/FinalScene.tscn")


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/Level4.tscn")
