extends Node2D

@onready var label: Label = $Label
@onready var label2: Label = $Label2
@onready var label3: Label = $Label3

func _ready() -> void:
	var player = get_node("../../Player")
	player.change_camera_limits(-140, -507, 3019, 1215)
	label.show()
	label2.show()
	label3.show()

func _process(_delta: float) -> void:
	if GameManager.first_time:
		label.show()
		label2.show()
		label3.show()
	elif not GameManager.first_time:
		label.hide()
		label2.hide()
		label3.hide()
		



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var main_node = get_tree().root.get_node("Main")
		if main_node and main_node.has_method("change_level"):
			main_node.change_level("res://scenes/level2.tscn", Vector2(0, 0))
