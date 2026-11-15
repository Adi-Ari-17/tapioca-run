extends CanvasLayer

signal menu_load
signal game_start
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
		GameManager.timecost += randi_range(3, 8)

func _on_play_pressed() -> void:
	game_start.emit()

func _on_pearl_1_pressed() -> void:
	GameManager.unlocked_states.append("pop")
	$Pearl1.disabled = true

func _on_pearl_2_pressed() -> void:
	GameManager.unlocked_states.append("sugar")
	$Pearl2.disabled = true
