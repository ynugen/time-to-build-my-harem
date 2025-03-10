extends Node2D

@onready var player = $Player  # Get reference to Player
@onready var moves_label = $CanvasLayer/UI/Sprite2D/MovesLabel
@onready var camera = $Camera2D
var moves_left = MAX_MOVES

const MAX_MOVES = 10

func _ready():
	moves_label.text = "10"


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

func update_moves(minus):
	moves_left -= minus
	moves_label.text = str(moves_left)

func check_moves():
	return moves_left

func shake():
	camera.shake(50.0)
	
