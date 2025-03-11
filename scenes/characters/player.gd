extends CharacterBody2D

@onready var animated_sprite2d = $AnimatedSprite2D
@onready var arrow_container = $"../CanvasLayer/UI/Sprite2D/ArrowContainer"
@onready var movement_label = get_node_or_null("../UI/MovementLabel")
@onready var tilemap = get_node_or_null("../TileMap")
@onready var level = get_node_or_null("..")

@onready var floor_layer = get_node_or_null("../TileMap/FloorLayer")
@onready var wall_layer = get_node_or_null("../TileMap/WallLayer")

const EMPTY_TILE = -1  
const TILE_SIZE = 250  

@export var move_speed = 250
@export var push_distance = 250

var recorded_inputs = []
var is_recording = false
var is_playing = false
var is_finished = false
var playback_index = 0
var playback_timer = 0.0
var playback_interval = 0.4  

var arrow_scene = preload("res://scenes/characters/arrow_sprite.tscn")
var max_arrows_per_line = 10  # Number of arrows per line
var arrow_y_offset = 10  # Vertical spacing between rows

func _ready():
	animated_sprite2d.play("default")

func _process(delta):
	if is_recording:
		record_input()

	if is_playing:
		playback_timer -= delta
		if playback_timer <= 0 and playback_index < recorded_inputs.size():
			print("Applying move:", recorded_inputs[playback_index])  # Debug
			apply_input(recorded_inputs[playback_index])
			playback_index += 1
			playback_timer = playback_interval  # Reset timer for next input
		elif playback_index >= recorded_inputs.size():
			is_finished = true
	
	if is_finished:
		level._on_restart_pressed()  


func record_input():
	var input_data = get_input_action()
	if input_data:
		if level.check_moves() > 0:
			recorded_inputs.append(input_data)
			level.update_moves(1)
			update_label()
			add_arrow_to_ui(input_data)
		else:
			print("Ran out of moves!")
			#check_game_over()

func get_input_action():
	if Input.is_action_just_pressed("ui_right"):
		return "→ Right"
	elif Input.is_action_just_pressed("ui_left"):
		return "← Left"
	elif Input.is_action_just_pressed("ui_up"):
		return "↑ Up"
	elif Input.is_action_just_pressed("ui_down"):
		return "↓ Down"
	return null

func add_arrow_to_ui(direction):
	var arrow = arrow_scene.instantiate()
	arrow.texture = load("res://assets/sprites/ui/%s arrow.png" % direction.split(" ")[1].to_lower())
	
	var arrow_x_position = (recorded_inputs.size() % max_arrows_per_line) * 4  # Horizontal position
	var arrow_y_position = (recorded_inputs.size() / max_arrows_per_line) * arrow_y_offset
	
	arrow_container.add_child(arrow)
	arrow.position = Vector2(recorded_inputs.size() * 4, 0)

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
	var player_tile = tilemap.local_to_map(global_position)
	var direction_int = Vector2i(direction)
	var next_tile = player_tile + direction_int
	var wall_tile = wall_layer.get_cell_source_id(next_tile)

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + direction * push_distance, 1)
	var result = space_state.intersect_ray(query)

	# If there's a wall, don't move
	if wall_tile != EMPTY_TILE:
		level.shake()
		return  

	# If nothing in the way, move the player
	if result.is_empty():
		global_position += direction * push_distance  
		return  

	# Handle collision (pushing objects or checking win condition)
	animated_sprite2d.play("default")
	handle_collision(result, direction)

func handle_collision(result, direction):
	var collider = result.get("collider")  # Use .get() to avoid errors if no collider is found

	if collider is CharacterBody2D and collider.has_method("win"):
		print("found waifu")
		level.win()
	elif collider is CharacterBody2D and collider.has_method("dead"):
		animated_sprite2d.play("punch")
		level.shake()
		collider.attacked()
	elif collider is StaticBody2D and collider.has_method("push"):
		push_object(collider, direction)

func push_object(collider, direction):
	var rock_next_pos = collider.global_position + direction * push_distance
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(collider.global_position, rock_next_pos, 1)
	var result = space_state.intersect_ray(query)

	var rock_next_tile = tilemap.local_to_map(rock_next_pos)
	var wall_after_rock = wall_layer.get_cell_source_id(rock_next_tile)

	# If the rock can move, push it and shake the level
	if result.is_empty() and wall_after_rock == EMPTY_TILE:
		collider.push(direction)
		level.shake()
	else:
		level.shake()
		print("Rock cannot be pushed further!")


func update_label():
	if movement_label:
		movement_label.text = "Moves: " + ", ".join(recorded_inputs)

func check_game_over():
	if level.check_moves() <= 0:
		print("Game Over! Restarting Level...")
		level._on_restart_pressed()  

func start_recording():
	recorded_inputs.clear()
	is_recording = true
	is_playing = false
	is_finished = false
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
	
	
