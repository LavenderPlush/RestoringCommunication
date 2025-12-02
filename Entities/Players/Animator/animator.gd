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

func handle_animations(delta):
	match state:
		State.IDLE:
			move_amount = lerpf(move_amount, -1, blend_speed * delta)
			climb_amount = 0.0
		State.MOVING:
			move_amount = lerpf(move_amount, (player_velocity / speed), speed * delta)
			climb_amount = 0.0

func _process(delta: float) -> void:
	handle_animations(delta)
	update_tree()

func jump():
	transition("Jumping")
	state = State.FALLING
	jump_amount = 1.0

func set_falling():
	if state == State.FALLING:
		return
	# animation_tree["parameters/JumpSeek/seek_request"] = 0.7
	transition("Jumping")
	state = State.FALLING

func land():
	if !animation_tree["parameters/Land/active"]:
		animation_tree["parameters/Land/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		state = State.IDLE
		transition("Idle")

func move(velocity: float):
	player_velocity = abs(velocity)
	if player_velocity > 0.0 and state == State.IDLE:
		# animation_tree["parameters/Land/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
		state = State.MOVING
		transition("Moving")
	elif player_velocity == 0.0 and state == State.MOVING:
		state = State.IDLE
		transition("Idle")

func transition(new_state: String):
	animation_tree["parameters/State/transition_request"] = new_state
