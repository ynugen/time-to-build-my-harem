extends CharacterBody2D

@onready var animated_sprite2d = $AnimatedSprite2D

@onready var movement_label = get_node_or_null("../UI/MovementLabel")
@onready var tilemap = get_node_or_null("../TileMap")
@onready var level = get_node_or_null("..")

# Access the child layers
@onready var floor_layer = get_node_or_null("../TileMap/FloorLayer")  # Adjust path if necessary
@onready var wall_layer = get_node_or_null("../TileMap/WallLayer")

const EMPTY_TILE = -1   # Empty tile index (no tile)
const TILE_SIZE = 250      # Adjust based on your tile size

# define variables
var recorded_inputs = []  # Stores input sequence
var is_recording = false
var is_playing = false
var playback_index = 0
var playback_timer = 0.0
var playback_interval = 0.2  # Time between actions during playback

@export var move_speed = 250
@export var push_distance = 250

func _ready():
	animated_sprite2d.play("default")

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
		if level.check_moves() > 0:
			recorded_inputs.append(input_data)
			level.update_moves(1)
			update_label()
		else:
			print("Ran out of moves!")

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
	var wall_tile = wall_layer.get_cell_source_id(next_tile)
	
	print("Player Tile ID:", player_tile)
	print("Wall Tile ID:", wall_tile)
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + direction * push_distance, 1)
	var result = space_state.intersect_ray(query)
	
	if wall_tile != EMPTY_TILE:
		pass
	elif result.is_empty():
		global_position += direction * push_distance  # Move player
	else:
		var collider = result["collider"]
		if collider is CharacterBody2D and collider.has_method("win"):
			level.win()
			return
		
		elif collider is StaticBody2D and collider.has_method("push"):
			var rock_next_pos = collider.global_position + direction * push_distance
			var query2 = PhysicsRayQueryParameters2D.create(collider.global_position, rock_next_pos, 1)
			var result2 = space_state.intersect_ray(query2)
			
			var rock_next_tile = tilemap.local_to_map(rock_next_pos)
			var wall_after_rock = wall_layer.get_cell_source_id(rock_next_tile)
			
			if result2.is_empty() and wall_after_rock == EMPTY_TILE:
				collider.push(direction)
				level.shake()
			else:
				print("Rock cannot be pushed further!")

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
