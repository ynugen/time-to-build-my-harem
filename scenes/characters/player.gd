extends CharacterBody2D

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
	var input_data = {}
	
	if Input.is_action_just_pressed("ui_right"):
		input_data["action"] = "move_right"
	elif Input.is_action_just_pressed("ui_left"):
		input_data["action"] = "move_left"
	elif Input.is_action_just_pressed("ui_up"):
		input_data["action"] = "move_up"
	elif Input.is_action_just_pressed("ui_down"):
		input_data["action"] = "move_down"

	if input_data:
		recorded_inputs.append(input_data)

func apply_input(input_data):
	velocity = Vector2.ZERO
	
	match input_data["action"]:
		"move_right":
			velocity.x = 500
		"move_left":
			velocity.x = -500
		"move_up":
			velocity.y = -500
		"move_down":
			velocity.y = 500
	
	move_and_slide()

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
