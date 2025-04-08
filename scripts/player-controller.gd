class_name PlayerController extends CharacterBody2D

@export var walk_speed = 200;
@export var deceleration = 0.1;
@export var jump_velocity = -400;

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

func _physics_process(delta: float) -> void:
	# Gravity.
	if not is_on_floor():
		velocity.y += gravity * delta;

	# Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity;

	# Horizontal movement.
	var input_direction = Input.get_axis("left", "right")

	if (input_direction):
		velocity.x = input_direction * walk_speed;
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed);

	move_and_slide();
