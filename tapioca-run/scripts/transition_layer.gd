extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

func fade_in() -> void:
	if GameManager.first_time:
		animation_player.play("first timey")
	else:
		animation_player.play("fade in")
	await animation_player.animation_finished
	
func fade_out() -> void:
	animation_player.play("fade out")
	await animation_player.animation_finished
