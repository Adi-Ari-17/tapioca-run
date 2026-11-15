extends CanvasLayer


signal shop_load
signal menu_load

func _ready() -> void:
	var tree := get_tree()
	$ColorRect.visible = tree.paused
	$menu.visible = tree.paused
	$shop.visible = tree.paused
	$resume.visible = tree.paused

func _physics_process(_delta: float) -> void:
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
	menu_load.emit()


func _on_shop_pressed() -> void:
	shop_load.emit()


func _on_resume_pressed() -> void:
	toggle_pause()
