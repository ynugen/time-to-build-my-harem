extends AudioStreamPlayer

var is_music_playing = false
var current_track: AudioStream = null

func _ready():
	# Make sure music keeps playing across scenes
	if not is_music_playing:
		if current_track:
			stream = current_track
		else:
			current_track = preload("res://assets/audio/soundtrack/5000 years.mp3")
			stream = current_track
		
		play()
		is_music_playing = true

func play_music(new_track: AudioStream):
	# Only change music if it's a different track
	if current_track != new_track:
		current_track = new_track
		stream = new_track
		play()

func _on_music_finished():
	# Loop the current track
	play()

func set_volume(volume: float):
	volume_db = linear_to_db(volume)
