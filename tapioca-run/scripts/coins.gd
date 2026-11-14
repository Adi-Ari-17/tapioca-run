extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("idle")

func _on_area_entered(area: Area2D) -> void:
	GameManager.coins += 1
	queue_free()
