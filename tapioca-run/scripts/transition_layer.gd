extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_in() -> void:
	animation_player.play("fade in")
	await animation_player.animation_finished
	
func fade_out() -> void:
	animation_player.play("fade out")
	await animation_player.animation_finished
