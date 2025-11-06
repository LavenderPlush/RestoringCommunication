extends Node
class_name Movement

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
var is_climbing: bool = false
var is_facing_left: bool = false

func process_climb(can_climb: bool):
	var climb_input_vertical = Input.get_axis(
		"%s_move_backward" % control_prefix, 
		"%s_move_forward" % control_prefix
	)
	
	if !is_climbing and climb_input_vertical != 0:
		is_climbing = true
	
	if is_climbing:
		body.velocity.y = climb_input_vertical * climb_speed
		body.velocity.z = 0
	
	if (!can_climb
		or body.is_on_floor()
		or Input.is_action_just_pressed("%s_jump" % control_prefix)):
		is_climbing = false

func process_gravity(delta: float):
	if not body.is_on_floor():
		body.velocity.y -= gravity * delta

func process_jump():
	if is_climbing:
		body.velocity.y = 0
		is_climbing = false
	if (Input.is_action_just_pressed("%s_jump" % control_prefix)
		and body.is_on_floor()):
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
