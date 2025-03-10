extends Node2D

@onready var animPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("MeetCute")


func _on_success_choice_pressed() -> void:
	animPlayer.play("Success")


func _on_fail_choice_pressed() -> void:
	animPlayer.play("Fumble")
