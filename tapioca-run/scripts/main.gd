extends Node2D

@onready var level_node: Node2D = $level
@onready var player: CharacterBody2D = $Player
@onready var transition_layer: Node = $GUI/TransitionLayer
@onready var current_level_node: Node = null
@onready var countdown: Node = $GUI/countdown
@onready var hud: Node = $GUI/hud
signal countstart

func _ready() -> void:
	if player:
		player.hide()
		player.process_mode = PROCESS_MODE_DISABLED
	if countdown:
		countdown.hide()
	if hud:
		hud.hide()
	load_menu()

func load_menu() -> void:
	var menu_scene = load("res://scenes/menu.tscn").instantiate()
	level_node.add_child(menu_scene)
	menu_scene.game_start.connect(game_starting)
	menu_scene.shop_load.connect(shop_load)
	hud.hide()
	countdown.hide()

func game_starting() -> void:
	print("game start")
	if player:
		player.set_physics_process(true)
	change_level(GameManager.current_level, GameManager.spawn_pos)
	if countdown:
		countdown.show()
		print(GameManager.countdown)
		countstart.emit()
	if hud:
		hud.show()

func change_level(level: String, spawn_pos: Vector2) -> void:
	GameManager.controls_allowed = false
	if hud:
		hud.hide()
	if player:
		player.hide()
		player.set_physics_process(false)
		player.global_position = spawn_pos
	if transition_layer:
		await transition_layer.fade_in()
	for child in level_node.get_children():
		child.queue_free()
	var new_level = load(level)
	if new_level:
		current_level_node = new_level.instantiate()
		level_node.add_child(current_level_node)
	if player:
		player.set_physics_process(true)
		player.process_mode = Node.PROCESS_MODE_INHERIT
		player.show()
	if transition_layer:
		transition_layer.fade_out()
		await get_tree().create_timer(0.5).timeout
		GameManager.controls_allowed = true

func return_to_menu() -> void:
	GameManager.controls_allowed = false
	if player:
		player.hide()
		player.set_physics_process(false)
	if hud:
		hud.hide()
	if transition_layer:
		await transition_layer.fade_in()
	for child in level_node.get_children():
		child.queue_free()
	var menu_scene = load("res://scenes/menu.tscn").instantiate()
	level_node.add_child(menu_scene)
	if transition_layer:
		transition_layer.fade_out()
	menu_scene.game_start.connect(game_starting)
	
func shop_load() -> void:
	if transition_layer:
		await transition_layer.fade_in()
	for child in level_node.get_children():
		child.queue_free()
	var shop_scene = load("res://scenes/shop.tscn").instantiate()
	level_node.add_child(shop_scene)
	if transition_layer:
		transition_layer.fade_out()
	
