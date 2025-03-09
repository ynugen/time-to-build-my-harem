extends CharacterBody2D

@onready var movement_label = get_node_or_null("../UI/MovementLabel")

# define variables
var recorded_inputs = []  # Stores input sequence
var is_recording = false
var is_playing = false
var playback_index = 0
var playback_timer = 0.0
var playback_interval = 0.2  # Time between actions during playback

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
	
	match input_data:
		"→ Right":
			velocity.x = 2000
		"← Left":
			velocity.x = -2000
		"↑ Up":
			velocity.y = -2000
		"↓ Down":
			velocity.y = 2000
	
	move_and_slide()

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
