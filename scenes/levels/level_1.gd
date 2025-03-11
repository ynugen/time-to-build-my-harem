extends Node2D

@onready var player = $Player  # Get reference to Player
@onready var moves_label = $CanvasLayer/UI/Sprite2D/MovesLabel
@onready var camera = $Camera2D
@onready var slime_girl = $TileMap/SlimeGirl
var moves_left = MAX_MOVES

const MAX_MOVES = 12

func _ready():
	var scene_music = preload("res://assets/audio/soundtrack/Slimey Fugue.mp3")
	AudioManager.play_music(scene_music)
	
	moves_label.text = "12"
	slime_girl.play()

func _input(event):
	if event.is_action_pressed("restart"):  # "ui_accept" is typically bound to the Enter key
		# Ignore the input event when Enter is pressed

		_on_restart_pressed()

func _on_play_pressed() -> void:
	if player:
		if moves_left == 0:
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
	
