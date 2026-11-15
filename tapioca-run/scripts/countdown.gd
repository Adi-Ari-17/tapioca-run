extends Node2D

@onready var label: Label = $Label
@onready var main: Node2D = null
signal shop_load
var waiting: bool = false
var counting
  
func _ready() -> void:
	main = get_tree().root.get_node("Main")

func _process(_delta: float) -> void:
	if counting:
		label.text = str(GameManager.countdown)
		if GameManager.countdown <= 0:
			shop_load.emit()
			counting = false
			hide()


func _on_main_countstart() -> void:
	counting = true
	label.text = str(GameManager.countdown)
	GameManager.countdown = GameManager.count_max
