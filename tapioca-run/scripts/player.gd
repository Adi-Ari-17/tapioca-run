extends CharacterBody2D

const SPEED = 200.0
var touched_floor = true
var can_double_jump = false
var wall_cooldown_timer: float = 0.0
const WALL_COOLDOWN_DURATION: float = 2.0

# Grace period tracking variables
var was_wall_sliding: bool = false
var wall_time_elapsed: float = 0.0
const WALL_GRACE_PERIOD: float = 0.25

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitfx: GPUParticles2D = $HitFX/GPUParticles2D
@onready var wall_progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	update_animation()
	wall_progress_bar.visible = false

func _physics_process(delta: float) -> void:
	# Handle cooldown timer and progress bar visibility
	if wall_cooldown_timer > 0:
		wall_cooldown_timer -= delta
		wall_progress_bar.visible = true
		wall_progress_bar.value = wall_cooldown_timer
	else:
		wall_progress_bar.visible = false

	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_double_jump = true
		if was_wall_sliding and wall_time_elapsed >= WALL_GRACE_PERIOD:
			wall_cooldown_timer = WALL_COOLDOWN_DURATION
		was_wall_sliding = false
		wall_time_elapsed = 0.0

	if GameManager.controls_allowed == true:
		var direction := Input.get_axis("left", "right")
		
		var can_wall_slide = not is_on_floor() and is_on_wall() and GameManager.player_state == "sugar" and wall_cooldown_timer <= 0
		var is_pushing_against_wall = (direction < 0 and $Sprite2D.flip_h) or (direction > 0 and not $Sprite2D.flip_h)
		
		if can_wall_slide and (is_pushing_against_wall or Input.is_action_pressed("up") or Input.is_action_pressed("down")):
			was_wall_sliding = true
			wall_time_elapsed += delta 
			
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
			if was_wall_sliding and (is_on_floor() or not is_on_wall()):
				if wall_time_elapsed >= WALL_GRACE_PERIOD:
					wall_cooldown_timer = WALL_COOLDOWN_DURATION
					
				was_wall_sliding = false
				wall_time_elapsed = 0.0

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
				
		if Input.is_action_just_pressed("up") and not is_on_floor():
			if GameManager.player_state == "pop" and can_double_jump:
				velocity.y = -280.0
				can_double_jump = false 
				
		# Switch state when pressing interact (checks if player has enough currency and unlocked states)
		if Input.is_action_just_pressed("interact"):
			try_switch_state()
			
	move_and_slide()

func try_switch_state() -> void:
	# Check if player has at least 50 countdown currency
	if GameManager.countdown >= 50:
		var current_index = GameManager.unlocked_states.find(GameManager.player_state)
		
		# If current state is valid and there are multiple unlocked states to cycle through
		if current_index != -1 and GameManager.unlocked_states.size() > 1:
			# Deduct cost
			GameManager.countdown -= 50
			
			# Move to the next unlocked state in the array, wrapping around if at the end
			var next_index = (current_index + 1) % GameManager.unlocked_states.size()
			GameManager.player_state = GameManager.unlocked_states[next_index]
			
			update_animation()
	else:
		print("Not enough countdown to switch states!")

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
