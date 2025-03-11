extends Control

@onready var easter_eggs: AnimationPlayer = $EasterEggs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")


func _on_retry_pressed() -> void:
	easter_eggs.play("LeafGirl")
