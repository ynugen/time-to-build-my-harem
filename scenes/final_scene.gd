extends Control

@onready var easter_eggs: AnimationPlayer = $EasterEggs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	easter_eggs.play("EndingScene")

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")


func _on_exit_pressed() -> void:
	easter_eggs.play("EndingScene")


func _on_lava_button_pressed() -> void:
	easter_eggs.play("LavaGirl")


func _on_leaf_button_pressed() -> void:
	easter_eggs.play("LeafGirl")


func _on_rock_button_pressed() -> void:
	easter_eggs.play("RockGirl")


func _on_slime_button_pressed() -> void:
	easter_eggs.play("SlimeGirl")
