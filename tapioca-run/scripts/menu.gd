extends CanvasLayer

signal game_start
signal shop_load

func _on_start_pressed() -> void:
	game_start.emit()

func _on_credits_pressed() -> void:
	pass

func _on_shop_pressed() -> void:
	shop_load.emit()
