extends Node2D

@onready var label: Label = $Label
@onready var label2: Label = $Label2
@onready var label3: Label = $Label3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.show()
	label2.show()
	label3.show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.first_time:
		label.show()
		label2.show()
		label3.show()
	elif not GameManager.first_time:
		label.hide()
		label2.hide()
		label3.hide()
		
