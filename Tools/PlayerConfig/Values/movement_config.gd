extends Control

@export var player: Movement

# Option 1
@export var speed_control: LineEdit

# Option 2
@export var jump_control: LineEdit

# Option 3
@export var climb_control: LineEdit

func _ready() -> void:
	speed_control.text = str(player.speed)
	jump_control.text = str(player.jump_velocity)
	climb_control.text = str(player.climb_speed)

func _process(_delta: float) -> void:
	player.speed = float(speed_control.text)
	player.jump_velocity = float(jump_control.text)
	player.climb_speed = float(climb_control.text)
