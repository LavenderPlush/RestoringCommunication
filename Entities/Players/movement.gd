extends Node
class_name movement

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_category("Designers")
@export var speed: float = 5
@export var jump_velocity: float = 8.5
@export var climb_speed: float = 4

@export_group("Developers")
## human / alien
@export var control_prefix: String
@export var body: CharacterBody3D

# Exposed
var is_facing_left: bool = false

func process_climb():
	var climb_input_vertical = Input.get_axis(
		"%s_move_backward" % control_prefix, 
		"%s_move_forward" % control_prefix
	)
	var climb_input_horizontal = Input.get_axis(
		"%s_move_left" % control_prefix, 
		"%s_move_right" % control_prefix
	)

	body.velocity.y = climb_input_vertical * climb_speed
	body.velocity.z = climb_input_horizontal * speed
	body.velocity.x = 0

func process_gravity():
	body.velocity.y -= gravity

func process_jump():
	body.velocity.y = jump_velocity

func process_movement():
	var input_direction = Input.get_vector(
		"%s_move_left" % control_prefix,
		"%s_move_right" % control_prefix,
		"%s_move_forward" % control_prefix,
		"%s_move_backward" % control_prefix
	)
	var direction = Vector3.ZERO

	direction.z = input_direction.x

	if direction:
		body.velocity.z = direction.z * speed
		_set_facing_direction(direction)
	else:
		body.velocity.z = move_toward(body.velocity.z, 0, speed)

func _set_facing_direction(direction: Vector3) -> void:
	is_facing_left = true if direction.z < 0 else false
