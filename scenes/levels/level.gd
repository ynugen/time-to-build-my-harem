extends Node2D

@onready var player = $Player  # Get reference to Player
#@onready var moves_label = $CanvasLayer/UI/Sprite2D/MovesLabel
@onready var camera = $Camera2D

@export var waifu : CharacterBody2D
@export var max_moves : int : set = set_max_moves
@export var win_cutscene : PackedScene
@export var moves_label : Label

var moves_left = max_moves

var recorded : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_moves_label()
	waifu.play()

# Change to cutscene on win
func win():
	get_tree().change_scene_to_packed(win_cutscene)
	
func set_max_moves(value: int) -> void:
	max_moves = value
	update_moves_label()

func update_moves_label() -> void:
	if moves_label:
		moves_label.text = str(max_moves)

# Play actions
func _on_play_pressed() -> void:
	if player:
		player.start_playback()

func _on_stop_recording_pressed() -> void:
	if player:
		player.stop_recording()
		recorded = true

# Record actions
func _on_start_recording_pressed() -> void:
	if player and not recorded:
		player.start_recording()

# Restart Level
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func update_moves(minus):
	moves_left -= minus
	moves_label.text = str(moves_left)

func check_moves():
	return moves_left

func shake():
	camera.shake(50.0)
