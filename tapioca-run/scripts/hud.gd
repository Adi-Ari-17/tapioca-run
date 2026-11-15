extends Node2D
@onready var label: Label = $Label

func _ready() -> void:
	label.text = str(GameManager.coins)
	
func _physics_process(_delta: float) -> void:
	label.text = str(GameManager.coins)
