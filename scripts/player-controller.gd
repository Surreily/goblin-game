class_name PlayerController extends CharacterBody2D

@export var walk_speed = 200
@export var deceleration = 0.1
@export var jump_velocity = -400

var graphics: Node2D
var animation: AnimationPlayer

func _ready() -> void:
	graphics = get_node("Graphics")
	animation = get_node("Animation")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Gravity.
	if not is_on_floor():
		velocity.y += gravity * delta;

	# Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity;

	# Horizontal movement.
	var input_direction = Input.get_axis("left", "right")

	if input_direction:
		velocity.x = input_direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)

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
