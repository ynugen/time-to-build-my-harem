extends Node2D
@onready var window: Window = get_window()
@onready var base_size: Vector2i = window.content_scale_size

func _ready():
	window.size_changed.connect(_on_window_size_changed)

	var min_x = ProjectSettings.get_setting("display/window/size/viewport_width")
	var min_y = ProjectSettings.get_setting("display/window/size/viewport_height")

	window.min_size = Vector2i(min_x, min_y)

func _on_window_size_changed():
	var clamped_size = window.size
	var scale = clamped_size / base_size

	# Ensure uniform scaling based on the smaller scale factor
	var scale_factor = min(scale.x, scale.y)
	window.content_scale_size = window.size / scale_factor
