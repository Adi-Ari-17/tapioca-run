extends CharacterBody2D

const SPEED = 200.0
var touched_floor = true
var can_double_jump = false
var wall_cooldown_timer: float = 0.0
const WALL_COOLDOWN_DURATION: float = 2.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitfx: GPUParticles2D = $HitFX/GPUParticles2D
@onready var wall_progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	update_animation()

func _physics_process(delta: float) -> void:
	if wall_cooldown_timer > 0:
		wall_cooldown_timer -= delta
	if wall_progress_bar:
		wall_progress_bar.value = wall_cooldown_timer
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_double_jump = true
	if GameManager.controls_allowed == true:
		var direction := Input.get_axis("left", "right")
		var touching_wall = not is_on_floor() and is_on_wall() and GameManager.player_state == "sugar"
		if touching_wall and wall_cooldown_timer <= 0:
			wall_cooldown_timer = WALL_COOLDOWN_DURATION
		var is_wall_active = touching_wall and wall_cooldown_timer > 0
		if is_wall_active:
			if Input.is_action_pressed("up"):
				velocity.y = -150.0 
			elif Input.is_action_pressed("down"):
				velocity.y = 150.0 
			else:
				velocity.y = min(velocity.y, 40.0)
			if direction != 0:
				velocity.x = direction * SPEED
				$Sprite2D.flip_h = (direction < 0)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			if direction:
				velocity.x = direction * SPEED
				$Sprite2D.flip_h = (direction < 0) 
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and touched_floor:
			play_bounce_animation()
			if GameManager.player_state == "sugar":
				velocity.y = -250.0 
				GameManager.countdown -= 1
			else:
				GameManager.countdown -= 1
				velocity.y = -325.0 
		if Input.is_action_just_pressed("up") and not is_on_floor() and not is_wall_active:
			if GameManager.player_state == "pop" and can_double_jump:
				velocity.y = -280.0
				can_double_jump = false 
		if Input.is_action_just_pressed("interact"):
			cycle_state()
	move_and_slide()

func cycle_state() -> void:
	if GameManager.player_state == "normal":
		GameManager.player_state = "pop"
	elif GameManager.player_state == "pop":
		GameManager.player_state = "sugar"
	elif GameManager.player_state == "sugar":
		GameManager.player_state = "normal"
	update_animation()

func update_animation() -> void:
	if GameManager.player_state == "normal":
		animation_player.play("idle-normal")
	elif GameManager.player_state == "pop":
		animation_player.play("idle-pop")
	elif GameManager.player_state == "sugar":
		animation_player.play("idle-sugar")

func play_bounce_animation() -> void:
	if GameManager.player_state == "normal":
		animation_player.play("down-bounce-normal")
	elif GameManager.player_state == "pop":
		animation_player.play("down-bounce-pop")
	elif GameManager.player_state == "sugar":
		animation_player.play("down-bounce-sugar")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "down-bounce-normal":
		animation_player.play("idle-normal")
	elif anim_name == "down-bounce-pop" or anim_name == "dowm-bounce_pop":
		animation_player.play("idle-pop")
	elif anim_name == "down-bounce-sugar":
		animation_player.play("idle-sugar")

func _on_hurbox_entered(area: Area2D) -> void:
	if area.is_in_group("hazards"):
		GameManager.controls_allowed = false
		var dir = 1 if randf() > 0.5 else -1
		velocity = Vector2(-200 * dir, -300)
		GameManager.countdown -= 10
		hitfx.restart()
		await get_tree().create_timer(0.5).timeout
		GameManager.controls_allowed = true
