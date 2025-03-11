extends Node2D

#@onready var player = $Player  # Get reference to Player
@onready var moves_label = $CanvasLayer/UI/Sprite2D/MovesLabel
@onready var camera = $Camera2D

# Variables defined in inpsector panel
@export var player : CharacterBody2D
@export var waifu : CharacterBody2D
@export var meet_cutscene: PackedScene
@export var MAX_MOVES: int


var moves_left : int
var is_recording = false  # Tracks recording state

func _ready():
	moves_left = MAX_MOVES
	moves_label.text = str(MAX_MOVES)
	waifu.play()

func _process(delta):
	if is_recording and Input.is_action_pressed("ui_accept"):
		stop_recording_and_play()

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
		is_recording = true

func stop_recording_and_play():
	if player:
		player.stop_recording()
		player.start_playback()
		is_recording = false

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func win():
	get_tree().change_scene_to_packed(meet_cutscene)

# Called in player
func update_moves(minus):
	moves_left -= minus
	moves_label.text = str(moves_left)

func check_moves():
	return moves_left

func shake():
	camera.shake(50.0)
	
