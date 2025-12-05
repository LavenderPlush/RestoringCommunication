@abstract
extends CharacterBody3D
class_name Player

@export var movement: Movement
@export var animator: Animator
@export var ability: Ability
@export var action_prefix: StringName = &""

var ability_active: bool = false
var can_climb: bool = false
var climb_snap_position: float = 0

var weighed_down: bool = false

func _ready() -> void:
	ability.engaged.connect(ability_engaged)
	ability.disengaged.connect(ability_disengaged)

# Setters
func set_can_climb(new_can_climb: bool) -> void:
	can_climb = new_can_climb

func set_climb_snap(new_position: float) -> void:
	climb_snap_position = new_position

# Getters
func get_interact_action() -> StringName:
	return StringName(action_prefix + "_interact")

func get_controlled_body() -> CharacterBody3D:
	return self

# Signals
func ability_engaged():
	ability_active = true
	
func ability_disengaged():
	ability_active = false

func reset_state():
	if ability_active:
		ability_disengaged()

	ability_active = false
