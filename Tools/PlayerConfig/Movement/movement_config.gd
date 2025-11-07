extends Control

@export var alien: Player
@export var human: Player

var human_movement: Movement
var alien_movement: Movement

@export var label: Label

# Option 1
@export var speed_control: LineEdit

# Option 2
@export var jump_control: LineEdit

# Option 3
@export var climb_control: LineEdit

# Option 4
@export var gravity: LineEdit

func _ready() -> void:
	label.text = "Movement"
	human_movement = human.movement
	alien_movement = alien.movement
	speed_control.text = str(human_movement.speed)
	jump_control.text = str(human_movement.jump_velocity)
	climb_control.text = str(human_movement.climb_speed)
	gravity.text = str(human_movement.gravity)

func _process(_delta: float) -> void:
	# Human
	human_movement.speed = float(speed_control.text)
	human_movement.jump_velocity = float(jump_control.text)
	human_movement.climb_speed = float(climb_control.text)
	# Alien
	alien_movement.speed = float(speed_control.text)
	alien_movement.jump_velocity = float(jump_control.text)
	alien_movement.climb_speed = float(climb_control.text)
	# Gravity
	ProjectSettings.set_setting("physics/3d/default_gravity", float(gravity.text))
