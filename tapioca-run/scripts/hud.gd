extends Node2D

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = str(GameManager.coins)
	
func _physics_process(delta: float) -> void:
	label.text = str(GameManager.coins)
