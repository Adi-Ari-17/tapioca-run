extends Node2D

@onready var label: Label = $Label

var waiting: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = str(GameManager.countdown)
  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.countstart:
		if not waiting:
			GameManager.countdown -= 1
			label.text = str(GameManager.countdown)
			if GameManager.countdown <= 0:
				queue_free()
		_trigger()

func _trigger() -> void:
	if waiting:
		return
	waiting = true
	await get_tree().create_timer(1.0).timeout
	waiting = false
