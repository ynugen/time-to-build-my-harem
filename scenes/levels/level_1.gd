extends Node2D

@onready var player = $Player  # Get reference to Player

func _on_play_pressed() -> void:
	if player:
		player.start_playback()


func _on_stop_recording_pressed() -> void:
	if player:
		player.stop_recording()


func _on_start_recording_pressed() -> void:
	if player:
		player.start_recording()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func win():
	get_tree().change_scene_to_file("res://scenes/cutScenes/SlimeCutScene.tscn")
