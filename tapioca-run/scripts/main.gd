extends Node2D

@onready var level_node: Node2D = $level
@onready var menu: Node2D = $"../menu"

func _ready() -> void:
	connect(game_start)
	load_menu()

func load_menu() -> void:
	var menu_scene = load("res://scenes/menu.tscn").instantiate()
	level_node.add_child(menu_scene)
