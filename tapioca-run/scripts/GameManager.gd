extends Node

var controls_allowed: bool = false
var current_level: String = "res://scenes/level_1.tscn"
var spawn_pos: Vector2 = Vector2(0, 0)
var coins: int = 0
var countdown: int = 0
var count_max: int = 50000
var timecost: int = 5
var first_time: bool = true
var player_state: String = "normal"
var unlocked_states: Array[String] = ["normal"]
