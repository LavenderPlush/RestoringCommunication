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

@export_group("Sound")
@export var footstep_sound_timer: Timer
@export var jump_emitter: FmodEventEmitter3D
@export var footstep_emitter: FmodEventEmitter3D
@export var land_emitter: FmodEventEmitter3D

# Exposed
var is_climbing: bool = false
var is_facing_left: bool = false
var is_walking: bool = false
var is_falling: bool = false

var _fall_velocity: float

func _ready() -> void:
	footstep_sound_timer.timeout.connect(_on_footstep_timer)

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
	if body.is_on_floor() and is_falling:
		is_falling = false
		_handle_landing_sound()
	elif not body.is_on_floor():
		is_falling = true
		_fall_velocity = abs(body.velocity.y)
		body.velocity.y -= gravity * delta

func process_jump():
	if (Input.is_action_just_pressed("%s_jump" % control_prefix)
		and body.is_on_floor()):
			_play_sound(jump_emitter)
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
		_handle_walk_sound()
		body.velocity.z = direction.z * speed
		_set_facing_direction(direction)
	else:
		is_walking = false
		body.velocity.z = move_toward(body.velocity.z, 0, speed)

func _handle_walk_sound():
	if not is_walking and body.is_on_floor():
		_play_sound(footstep_emitter)
		is_walking = true
		footstep_sound_timer.start()

func _handle_landing_sound():
	if not land_emitter:
		return

	# Magic number used for POC
	var normalized_velocity = clampf(_fall_velocity / 10.0, 0.0, 1.0)
	land_emitter.set_volume(normalized_velocity) 
	_play_sound(land_emitter)

func _play_sound(emitter: FmodEventEmitter3D):
	if emitter:
		emitter.play()

func _set_facing_direction(direction: Vector3) -> void:
	is_facing_left = true if direction.z < 0 else false

# Signals
func _on_footstep_timer():
	if not is_walking or not body.is_on_floor():
		return
	_play_sound(footstep_emitter)
	footstep_sound_timer.start()
	
