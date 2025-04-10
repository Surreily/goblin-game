class_name PlayerController extends CharacterBody2D

@export var walk_speed = 200
@export var walk_speed_in_water = 80
@export_range(0, 1) var walk_deceleration = 0.2
@export var jump_force = -400
@export var water_jump_force = -200
@export_range(0, 1) var jump_deceleration = 0.5
@export var terminal_velocity = 800
@export var terminal_velocity_in_water = 100
@export_range(0, 1) var water_deceleration = 0.2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var graphics: Node2D
var animation: AnimationPlayer
var is_in_water: bool = false

func _ready() -> void:
	graphics = get_node("Graphics")
	animation = get_node("Animation")
	is_in_water = false

func _physics_process(delta: float) -> void:
	# Gravity.
	if not is_on_floor():
		velocity.y = move_toward(
			velocity.y,
			terminal_velocity_in_water if is_in_water else terminal_velocity,
			gravity * delta * water_deceleration if is_in_water else gravity * delta)

	# Jump.
	if Input.is_action_just_pressed("jump"):
		if is_in_water:
			velocity.y = water_jump_force
		elif is_on_floor():
			velocity.y = jump_force
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_deceleration

	# Horizontal movement.
	var input_direction = Input.get_axis("left", "right")
	var final_walk_speed = walk_speed_in_water if is_in_water else walk_speed

	if input_direction:
		velocity.x = move_toward(
			velocity.x,
			input_direction * final_walk_speed,
			final_walk_speed * walk_deceleration)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			final_walk_speed * walk_deceleration)

	# Sprite direction.
	if velocity.x > 0.1:
		graphics.scale.x = 1
	elif velocity.x < -0.1:
		graphics.scale.x = -1

	# Animation.
	if not is_on_floor():
		if animation.current_animation != "jump":
			animation.play("jump")
	elif velocity:
		if animation.current_animation != "run":
			animation.play("run")
	else:
		if animation.current_animation != "idle":
			animation.play("idle")

	move_and_slide()
