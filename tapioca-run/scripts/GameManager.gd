extends Node

var controls_allowed: bool = false
var current_level: String = "res://scenes/level_1.tscn"
var spawn_pos: Vector2 = Vector2(0, 0)
var coins: int = 0
var countdown: int = 0
var count_max: int = 11
var countstart: bool = false
var menu: bool = false
