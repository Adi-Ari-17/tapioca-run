extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -325.0
var touched_floor: = true
var prev_velocity = 0.0
var jump_buffer_timer: float = 0.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		prev_velocity = velocity.y
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("up") and velocity.y < 0:
		velocity.y = 0
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor() and touched_floor:
		velocity.y = -prev_velocity
	move_and_slide()
