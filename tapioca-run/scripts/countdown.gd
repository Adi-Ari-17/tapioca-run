extends Node2D

@onready var label: Label = $Label
signal return_to_menu
var waiting: bool = false

func _ready() -> void:
	label.text = str(GameManager.countdown)
	GameManager.countdown = GameManager.count
  
func _process(delta: float) -> void:
	if GameManager.countstart:
		if not waiting:
			GameManager.countdown -= 1
			label.text = str(GameManager.countdown)
			if GameManager.countdown <= 0:
				return_to_menu.emit()
				GameManager.showCount = false
				queue_free()
		_trigger()

func _trigger() -> void:
	if waiting:
		return
	waiting = true
	await get_tree().create_timer(1.0).timeout
	waiting = false
