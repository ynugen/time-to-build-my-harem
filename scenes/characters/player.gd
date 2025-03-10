extends CharacterBody2D

@onready var movement_label = get_node_or_null("../UI/MovementLabel")
@onready var tilemap = get_node_or_null("../TileMap")
@onready var level = get_node_or_null("..")

# Access the child layers
@onready var floor_layer = get_node_or_null("../TileMap/FloorLayer")  # Adjust path if necessary
@onready var wall_layer = get_node_or_null("../TileMap/WallLayer")
@onready var object_layer = get_node_or_null("../TileMap/ObjectLayer")
@onready var girl_layer = get_node_or_null("../TileMap/GirlLayer")

const EMPTY_TILE = -1   # Empty tile index (no tile)
const TILE_SIZE = 250      # Adjust based on your tile size

# define variables
var recorded_inputs = []  # Stores input sequence
var is_recording = false
var is_playing = false
var playback_index = 0
var playback_timer = 0.0
var playback_interval = 0.2  # Time between actions during playback

func _ready():
	var layer_count = tilemap.get_layers_count()
	
	print("Total layers:", layer_count)
	
	for i in range(layer_count):
		print("Layer", i, " is visible:", tilemap.is_layer_enabled(i))

# frames
func _process(delta):
	if is_recording:
		record_input()

	if is_playing:
		playback_timer -= delta
		if playback_timer <= 0 and playback_index < recorded_inputs.size():
			apply_input(recorded_inputs[playback_index])
			playback_index += 1
			playback_timer = playback_interval  # Reset timer for next input

func record_input():
	var input_data = null
	
	if Input.is_action_just_pressed("ui_right"):
		input_data = "→ Right"
	elif Input.is_action_just_pressed("ui_left"):
		input_data = "← Left"
	elif Input.is_action_just_pressed("ui_up"):
		input_data = "↑ Up"
	elif Input.is_action_just_pressed("ui_down"):
		input_data = "↓ Down"

	if input_data:
		recorded_inputs.append(input_data)
		update_label()

func apply_input(input_data):
	velocity = Vector2.ZERO
	var direction = Vector2.ZERO 
	
	match input_data:
		"→ Right":
			direction = Vector2.RIGHT
		"← Left":
			direction = Vector2.LEFT
		"↑ Up":
			direction = Vector2.UP
		"↓ Down":
			direction = Vector2.DOWN
	
	if direction != Vector2.ZERO:
		move_or_action(direction)

func move_or_action(direction):
	var player_tile: Vector2i = tilemap.local_to_map(global_position)
	var direction_int = Vector2i(direction)  # convert movement to tilemap coordinates
	var next_tile = player_tile + direction_int  # tile in front of player
	
	var rock_tile = object_layer.get_cell_source_id(next_tile)
	var wall_tile = wall_layer.get_cell_source_id(next_tile)
	var girl_tile = girl_layer.get_cell_source_id(next_tile)
	print("Rock Tile ID:", rock_tile)
	print("Player Tile ID:", player_tile)

	if girl_tile != EMPTY_TILE:
		level.win()
	elif wall_tile != EMPTY_TILE:
		pass
	elif rock_tile != EMPTY_TILE:  # If a rock exists
		print("Rock exists at: ", next_tile)
		var rock_next_tile = next_tile + direction_int
		
		var after_rock_tile = object_layer.get_cell_source_id(rock_next_tile)
		
		if after_rock_tile == EMPTY_TILE:  # can push rock if next tile is empty
			print("Next tile is empty, moving rock")
			object_layer.set_cell(next_tile, EMPTY_TILE)  # remove rock from its original spot	
			object_layer.set_cell(rock_next_tile, rock_tile)  # move the rock forward
			
	
	else: # no rock in front
		print("No rock in front")
		position += direction * TILE_SIZE
	

func update_label():
	if movement_label:
		movement_label.text = "Moves: " + ", ".join(recorded_inputs)

func start_recording():
	recorded_inputs.clear()
	is_recording = true
	is_playing = false
	print("Recording started")

func stop_recording():
	is_recording = false
	print("Recording stopped")

func start_playback():
		is_playing = true
		is_recording = false
		playback_index = 0
		playback_timer = 0.0
		print("Playback started")
