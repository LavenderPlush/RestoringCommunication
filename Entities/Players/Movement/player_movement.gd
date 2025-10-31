extends Node
class_name PlayerMovement

##human or alien
@export_category("Designers")
@export var player_prefix: String = "human"
@export var speed: float = 5
@export var jump_velocity: float = 8.5

@export_category("Developers")
@export var player_body: CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
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
	else:
		player_body.velocity.z = move_toward(player_body.velocity.z, 0, speed)

	player_body.velocity.x = 0

	player_body.move_and_slide()
