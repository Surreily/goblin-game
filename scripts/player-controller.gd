class_name PlayerController extends CharacterBody2D

@export var walk_speed = 200
@export_range(0, 1) var walk_deceleration = 0.2
@export var jump_force = -400
@export_range(0, 1) var jump_deceleration = 0.5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var graphics: Node2D
var animation: AnimationPlayer

func _ready() -> void:
	graphics = get_node("Graphics")
	animation = get_node("Animation")

func _physics_process(delta: float) -> void:
	# Gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_deceleration

	# Horizontal movement.
	var input_direction = Input.get_axis("left", "right")

	if input_direction:
		velocity.x = move_toward(velocity.x, input_direction * walk_speed, walk_speed * walk_deceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * walk_deceleration)

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
