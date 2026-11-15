extends CanvasLayer

signal shop_load
signal menu_load

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var tree := get_tree()
	$ColorRect.visible = tree.paused
	$menu.visible = tree.paused
	$shop.visible = tree.paused
	$resume.visible = tree.paused

func _physics_process(_delta: float) -> void:
	var tree := get_tree()
	$menu.visible = tree.paused
	$shop.visible = tree.paused
	$resume.visible = tree.paused
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	var tree := get_tree()
	tree.paused = not tree.paused
	$ColorRect.visible = tree.paused
	$menu.visible = tree.paused
	$shop.visible = tree.paused
	$resume.visible = tree.paused
	
func _on_menu_pressed() -> void:
	toggle_pause()
	menu_load.emit()


func _on_shop_pressed() -> void:
	toggle_pause()
	shop_load.emit()


func _on_resume_pressed() -> void:
	toggle_pause()
