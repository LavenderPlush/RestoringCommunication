class_name Animator extends Node3D

@export var animation_tree: AnimationTree

enum State {
	IDLE,
	MOVING,
	CLIMB,
	FALLING
}

var speed: float = 0:
	set(s): speed = s

var player_velocity: float = 0.0

var state: State = State.IDLE

var move_amount: float = -1.0  # -1.0 to 1.0
var climb_amount: float = 0.0 # 0.0 to 1.0
var jump_amount: float = 0.0  # 0.0 to 1.0

var blend_speed: float = 15


func update_tree():
	animation_tree["parameters/Move/blend_amount"] = move_amount
	animation_tree["parameters/Climb/blend_amount"] = climb_amount
	animation_tree["parameters/HoldJump/blend_amount"] = jump_amount

func handle_animations(delta):
	match state:
		State.IDLE:
			move_amount = lerpf(move_amount, -1, blend_speed * delta)
			climb_amount = 0.0
			jump_amount = 0.0
		State.FALLING:
			move_amount = -1.0
			climb_amount = 0.0
		State.MOVING:
			move_amount = lerpf(move_amount, -1.0 + (player_velocity / speed) * 2.1, blend_speed * delta)
			climb_amount = 0.0
			jump_amount = 0.0

func _process(delta: float) -> void:
	handle_animations(delta)
	update_tree()

func jump():
	if animation_tree["parameters/Jump/active"]:
		return
	animation_tree["parameters/Land/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/Jump/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	state = State.FALLING
	jump_amount = 1.0

func land():
	if animation_tree["parameters/Land/active"]:
		return
	animation_tree["parameters/Jump/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/Land/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	state = State.IDLE
	jump_amount = 0.0

func move(velocity: float):
	player_velocity = abs(velocity)
	if player_velocity > 0.0 and state == State.IDLE:
		animation_tree["parameters/Jump/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		animation_tree["parameters/Land/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		state = State.MOVING
	elif player_velocity == 0.0 and state == State.MOVING:
		state = State.IDLE
