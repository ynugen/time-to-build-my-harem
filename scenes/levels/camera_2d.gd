extends Camera2D

@export var start_offset = Vector2(500, 0)  # Adjust based on level size
@export var zoom_start = Vector2(2, 2)  # Initial zoom (higher = closer)
@export var zoom_target = Vector2(0.25, 0.25)  # Normal zoom level
@export var move_duration = 1.5  # Time in seconds for animation
@onready var fade_rect = get_node("../CanvasLayer/ColorRect") 

func _ready():
	# Start offscreen or zoomed in
	position += start_offset
	zoom = zoom_start

 # Animate to normal position
	var tween = create_tween()
	tween.tween_property(self, "position", position - start_offset, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "zoom", zoom_target, move_duration)
	
	fade_rect._ready()
