@abstract
extends CharacterBody3D
class_name Player

@export var control_prefix: String

enum State {
	IDLE,
	WALKING,
	JUMPING,
	CLIMBING
}

var ability_active: bool = false
var can_climb: bool = false
var is_facing_left: bool = false

var current_state: int = State.IDLE: set = set_state

func set_state(state: int):
	# Makes it easier to change animations
	current_state = state

func set_can_climb(new_can_climb: bool) -> void:
	can_climb = new_can_climb

func _physics_process(delta: float) -> void:
	pass

@abstract
func can_walk() -> bool

@abstract
func can_jump() -> bool
