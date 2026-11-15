extends CanvasLayer

signal menu_load

@onready var label: Label = $countdown/Label

func _physics_process(delta: float) -> void:
	label.text = str(GameManager.count_max - 1)
func _on_back_pressed() -> void:
	menu_load.emit()


func _on_countdown_pressed() -> void:
	if GameManager.coins >= 5:
		GameManager.coins -= 5
		GameManager.count_max +=5
