extends ColorRect
@export var fade_duration = 3  # Time in seconds for fade effect
func _ready():
	self.modulate.a = 1  # Start fully opaque
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, fade_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	queue_free()  # Remove the fade screen once done
