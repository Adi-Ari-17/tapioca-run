extends CharacterBody2D

var state: String = "normal"
const SPEED = 200.0
var touched_floor: = true
var prev_velocity = 0.0
var jump_buffer_timer: float = 0.0
var jump_buffer_duration: float = 0.12
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if state == "normal":
		animation_player.play("idle-normal")
	elif state == "pop":
		animation_player.play("idle-pop")
	elif state == "sugar":
		animation_player.play("idle-sugar")

func _physics_process(delta: float) -> void:
	print(GameManager.controls_allowed)
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta
	if not is_on_floor():
		prev_velocity = velocity.y
		velocity += get_gravity() * delta
	if GameManager.controls_allowed == true:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			$Sprite2D.flip_h = (direction < 0) 
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and touched_floor:
			if state == "normal":
				animation_player.play("down-bounce-normal")
			elif state == "pop":
				animation_player.play("down-bounce-pop")
			elif state == "sugar":
				animation_player.play("down-bounce-sugar")
			velocity.y = -325.0
		if Input.is_action_just_pressed("up"):
			if state == "normal":
				state = "pop"
			elif state == "pop":
				state = "sugar"
			elif state == "sugar":
				state = "normal"
	move_and_slide()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "down-bounce-normal":
		animation_player.play("idle-normal")
	if anim_name == "dowm-bounce_pop":
		animation_player.play("idle-pop")
	if anim_name == "down-bounce-sugar":
		animation_player.play("idle-sugar")

func _on_hurbox_entered(area: Area2D) -> void:
	if area.is_in_group("hazards"):
		var dir := Input.get_axis("left", "right")
		GameManager.controls_allowed = false
		velocity = Vector2(300, -400)
		await get_tree().create_timer(0.5).timeout
		GameManager.controls_allowed = true
