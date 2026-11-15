extends CanvasLayer

signal menu_load
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	menu_load.emit()


func _on_countdown_pressed() -> void:
	if GameManager.coins >= 5:
		GameManager.coins -= 5
		GameManager.count_max +=5
		GameManager.countdown = GameManager.count_max
