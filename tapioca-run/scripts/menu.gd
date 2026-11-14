extends Node2D

signal game_start


func _on_start_pressed() -> void:
	game_start.emit()

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_settings_pressed() -> void:
	pass # Replace with function body.
