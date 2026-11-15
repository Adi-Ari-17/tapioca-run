extends CanvasLayer

signal menu_load
@onready var timelabel: Label = $countdown/Label
@onready var coinlabel: Label = $Coins
@onready var costlabel1: Label = $countdown/Label2

func _ready() -> void:
	timelabel.text = str(GameManager.count_max - 1)
	coinlabel.text = "coins: " + str(GameManager.coins)
	costlabel1.text = "cost: " + str(GameManager.timecost)

func _physics_process(_delta: float) -> void:
	timelabel.text = "current time: " + str(GameManager.count_max - 1)
	coinlabel.text = "coins: " + str(GameManager.coins)
	costlabel1.text = "cost: " + str(GameManager.timecost)

func _on_back_pressed() -> void:
	menu_load.emit()

func _on_countdown_pressed() -> void:
	if GameManager.coins >= GameManager.timecost:
		GameManager.coins -= GameManager.timecost
		GameManager.count_max += 5
		GameManager.timecost += randf_range(3, 8)
