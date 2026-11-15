extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.frame = randi_range(0, 13)
	animated_sprite.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.coins += 1
		queue_free()
