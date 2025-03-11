extends Control

@onready var volume_slider = $MarginContainer/VBoxContainer/HBoxContainer/VolumeSlider # Adjust the path if needed


func _on_volume_slider_value_changed(value):
	AudioManager.set_volume(value)

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")


func _on_volume_slider_focus_exited() -> void:
	release_focus()
