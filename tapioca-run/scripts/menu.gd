extends Node2D

signal game_start
signal shop_load


func _on_start_pressed() -> void:
	game_start.emit()
	GameManager.showCount = true

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_shop_pressed() -> void:
	shop_load.emit()
