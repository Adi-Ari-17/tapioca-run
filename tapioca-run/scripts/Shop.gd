extends CanvasLayer



func _on_countdown_pressed() -> void:
	if GameManager.coins >= 5:
		GameManager.coins -= 5
		GameManager.count += 5
		GameManager.countdown = GameManager.count
