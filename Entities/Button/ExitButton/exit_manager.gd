extends Node

@export_category("Developers")
@export var button_a: ExitButton
@export var button_b: ExitButton
@export var door: Node3D
##This Object will keep resetting until Players reach this Checkpoint ID. Keep at -1 to always reset.
@export var reset_until_checkpoint_id: int = -1

var original_door_position: Vector3
var required_hold_time: float = 0.1
var door_offset: float = 4.0
var animation_duration: float = 1.0
var hold_timer: float = 0.1
var button_a_engaged: bool = false
var button_b_engaged: bool = false
var door_opened: bool = false

func _ready() -> void:
	if !button_a || !button_b || !door: return

	add_to_group("resettable")
	original_door_position = door.position

	button_a.engaged.connect(_on_button_a_engaged)
	button_a.disengaged.connect(_on_button_a_disengaged)
	button_b.engaged.connect(_on_button_b_engaged)
	button_b.disengaged.connect(_on_button_b_disengaged)

	set_process(false)

func _process(delta: float) -> void:
	if door_opened: return

	var is_valid_state = button_a_engaged && button_b_engaged

	if is_valid_state:
		hold_timer += delta

		if hold_timer >= required_hold_time:
			_open_doors()
	else:
		hold_timer = 0.0

	if !button_a_engaged && !button_b_engaged:
		set_process(false)

func _open_doors():
	door_opened = true

	button_a.lock_engaged()
	button_b.lock_engaged()

	var target_y = door.position.y + door_offset
	var tween := create_tween()

	tween.tween_property(door, "position:y", target_y, animation_duration)

	set_process(false)

func _on_button_a_engaged():
	button_a_engaged = true

	set_process(true)

func _on_button_a_disengaged():
	button_a_engaged = false

func _on_button_b_engaged():
	button_b_engaged = true

	set_process(true)

func _on_button_b_disengaged():
	button_b_engaged = false

func reset_state():
	if door_opened:
		door_opened = false
		hold_timer = 0.1
		door.position = original_door_position

		set_process(false)
