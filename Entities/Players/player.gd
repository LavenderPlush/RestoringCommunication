@abstract
extends CharacterBody3D
class_name Player

@export var movement: Movement
@export var ability: Ability

func _ready() -> void:
	ability.engaged.connect(ability_engaged)
	ability.disengaged.connect(ability_disengaged)

var ability_active: bool = false
var can_climb: bool = false

func set_can_climb(new_can_climb: bool) -> void:
	can_climb = new_can_climb

# Signals
func ability_engaged():
	ability_active = true
	
func ability_disengaged():
	ability_active = false
