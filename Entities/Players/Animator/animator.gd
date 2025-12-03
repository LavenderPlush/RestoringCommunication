class_name Animator extends Node3D

@export var movement: Movement
@export var animation_tree: AnimationTree

enum State {
	IDLE,
	MOVING,
	CLIMBING,
	FALLING
}

var state: State = State.IDLE

var hor_speed: float
var vert_speed: float

var move_amount: float = -1.0  # -1.0 to 1.0
var climb_amount: float = 0.0 # 0.0 to 1.0

var blend_speed: float = 15

func process(delta: float) -> void:
	handle_animations(delta)
	update_tree()
	if movement.on_floor():
		process_movement()
	if !movement.is_climbing:
		process_falling()
	process_climb()
	if (Input.is_action_just_pressed("%s_jump" % movement.control_prefix)
		and movement.on_floor()):
			jump()

func update_tree():
	animation_tree["parameters/Move/blend_amount"] = move_amount
	animation_tree["parameters/ClimbScale/scale"] = climb_amount * 5.0

func handle_animations(delta):
	match state:
		State.IDLE:
			move_amount = lerpf(move_amount, -1, blend_speed * delta)
			climb_amount = 0.0
		State.MOVING:
			move_amount = lerpf(move_amount, (hor_speed / movement.speed), movement.speed * delta)
			climb_amount = 0.0
		State.CLIMBING:
			climb_amount = lerpf(climb_amount, (vert_speed / movement.climb_speed), movement.climb_speed * delta)
			move_amount = 0.0

func jump():
	animation_tree["parameters/JumpScale/scale"] = 2.0
	transition("Jumping")
	state = State.FALLING

func process_falling():
	if state != State.FALLING and movement.is_falling:
		animation_tree["parameters/JumpScale/scale"] = 1.0
		transition("Jumping")
		state = State.FALLING
	elif state == State.FALLING and !movement.is_falling:
		idle()

func process_climb():
	vert_speed = abs(movement.body.velocity.y)
	if state != State.CLIMBING and movement.is_climbing:
		state = State.CLIMBING
		transition("Climbing")
	elif state == State.CLIMBING and !movement.is_climbing:
		idle()

func idle():
	state = State.IDLE
	transition("Idle")

func process_movement():
	hor_speed = abs(movement.body.velocity.z)
	if hor_speed > 0.0 and state == State.IDLE:
		state = State.MOVING
		transition("Moving")
	elif hor_speed == 0.0 and state == State.MOVING:
		state = State.IDLE
		transition("Idle")

func transition(new_state: String):
	animation_tree["parameters/State/transition_request"] = new_state
