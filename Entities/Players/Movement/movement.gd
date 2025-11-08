extends Node
class_name Movement

var gravity: float: 
	get(): return ProjectSettings.get_setting("physics/3d/default_gravity")

@export_category("Designers")
@export var speed: float = 5.0
@export var jump_velocity: float = 8.5
@export var climb_speed: float = 4.0
@export var slide_speed: float = 3.0

@export_group("Developers")
## human / alien
@export var control_prefix: String
@export var body: CharacterBody3D
@export var floor_rays: Array[RayCast3D]

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
	
	if !is_climbing and climb_input_vertical != 0 and can_climb:
		is_climbing = true
		body.global_position.z = body.climb_snap_position
	
	if is_climbing:
		body.velocity.y = climb_input_vertical * climb_speed
		body.velocity.z = 0
	
	if (!can_climb
		or on_floor()
		or Input.is_action_just_pressed("%s_jump" % control_prefix)):
		is_climbing = false

func process_gravity(delta: float):
	if on_floor() and is_falling:
		is_falling = false
		_handle_landing_sound()
	elif not on_floor():
		is_falling = true
		_fall_velocity = abs(body.velocity.y)
		body.velocity.y -= gravity * delta

func process_jump():
	if (Input.is_action_just_pressed("%s_jump" % control_prefix)
		and on_floor()):
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
	if not is_walking and on_floor():
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

func on_floor() -> bool:
	if floor_rays.is_empty():
		return body.is_on_floor()
	for ray in floor_rays:
		if !ray.is_colliding():
			continue
		var collider = ray.get_collider()
		if collider is not Player:
			return true
		else:
			_handle_land_on_player(collider)
	return false

func _handle_land_on_player(other_player: Player):
	var slide_direction = body.global_position - other_player.global_position
	body.velocity.z += slide_direction.normalized().z * slide_speed

# Setters
func set_body(_body: CharacterBody3D) -> void:
	body = _body

## Parameter has to be un-typed due to constraints of Godot
## _floor_rays: Array[RayCast3D]
func set_floor_rays(_floor_rays) -> void:
	floor_rays = []
	for ray in _floor_rays:
		floor_rays.append(ray as RayCast3D)

# Signals
func _on_footstep_timer():
	if not is_walking or not on_floor():
		return
	_play_sound(footstep_emitter)
	footstep_sound_timer.start()
	
