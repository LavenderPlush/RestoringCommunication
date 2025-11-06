@abstract
extends CharacterBody3D
class_name Player

@export var movement: Movement
@export var ability: Ability

var ability_active: bool = false
var can_climb: bool = false
var climb_snap_position: float = 0

func _ready() -> void:
	ability.engaged.connect(ability_engaged)
	ability.disengaged.connect(ability_disengaged)

# Setters
func set_can_climb(new_can_climb: bool) -> void:
	can_climb = new_can_climb

func set_climb_snap(new_position: float) -> void:
	climb_snap_position = new_position

# Signals
func ability_engaged():
	ability_active = true
	
func ability_disengaged():
	ability_active = false
