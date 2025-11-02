extends Node
class_name PlayerMovement

@export_category("Designers")
##human or alien
@export var player_prefix: String = "human"
@export var speed: float = 5
@export var jump_velocity: float = 8.5
@export var climb_speed: float = 4

@export_category("Developers")
@export var player_body: CharacterBody3D:
	set(body):
		player_body = body

var controls_locked: bool = false:
	set(value):
		controls_locked = value
var is_climbing: bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_facing_left: bool = false


func _physics_process(delta: float) -> void:
	if controls_locked:
		player_body.velocity.y -= gravity * delta
		player_body.move_and_slide()
		return

	if is_climbing:
		var climb_input_vertical = Input.get_axis(
			"%s_move_backward" % player_prefix, 
			"%s_move_forward" % player_prefix
		)
		var climb_input_horizontal = Input.get_axis(
			"%s_move_left" % player_prefix, 
			"%s_move_right" % player_prefix
		)

		player_body.velocity.y = climb_input_vertical * climb_speed
		player_body.velocity.z = climb_input_horizontal * speed
		player_body.velocity.x = 0

		if Input.is_action_just_pressed("%s_jump" % player_prefix):
			is_climbing = false
			player_body.velocity.y = jump_velocity
	else:
		if not player_body.is_on_floor():
			player_body.velocity.y -= gravity * delta

		if (Input.is_action_just_pressed("%s_jump" % player_prefix) and
			player_body.is_on_floor()):
			player_body.velocity.y = jump_velocity

		var input_direction = Input.get_vector(
			"%s_move_left" % player_prefix,
			"%s_move_right" % player_prefix,
			"%s_move_forward" % player_prefix,
			"%s_move_backward" % player_prefix
		)
		var direction = Vector3.ZERO

		direction.z = input_direction.x

		if direction:
			player_body.velocity.z = direction.z * speed
			_set_facing_direction(direction)
		else:
			player_body.velocity.z = move_toward(player_body.velocity.z, 0, speed)

		player_body.velocity.x = 0

	player_body.move_and_slide()

func set_is_climbing(new_is_climbing: bool) -> void:
	is_climbing = new_is_climbing

	if not is_climbing:
		player_body.velocity.y = 0

func _set_facing_direction(direction: Vector3) -> void:
	is_facing_left = true if direction.z < 0 else false
