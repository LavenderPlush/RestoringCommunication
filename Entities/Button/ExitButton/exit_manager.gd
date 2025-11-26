class_name ExitManager extends Node

@export_category("Developers")
@export var button_a: ExitButton
@export var button_b: ExitButton
@export var door: ExitDoor
@export var exit_area: Area3D
##This Object will keep resetting until Players reach this Checkpoint ID. Keep at -1 to always reset.
@export var reset_until_checkpoint_id: int = -1

signal exit(first_to_exit: String)

var original_door_position: Vector3
var required_hold_time: float = 0.1
var door_offset: float = 4.0
var animation_duration: float = 1.0
var hold_timer: float = 0.1
var button_a_engaged: bool = false
var button_b_engaged: bool = false
var door_opened: bool = false

var players_in_exit_area: Array[Player] = []

func _ready() -> void:
	if !button_a || !button_b || !door: return

	add_to_group("resettable")
	original_door_position = door.position

	button_a.engaged.connect(_on_button_a_engaged)
	button_a.disengaged.connect(_on_button_a_disengaged)
	button_b.engaged.connect(_on_button_b_engaged)
	button_b.disengaged.connect(_on_button_b_disengaged)

func _process(delta: float) -> void:
	if door_opened:
		return

	var is_valid_state = button_a_engaged && button_b_engaged

	if is_valid_state:
		hold_timer += delta

		if hold_timer >= required_hold_time:
			_open_doors()
	else:
		hold_timer = 0.0

func _open_doors():
	if door_opened:
		return

	door_opened = true

	button_a.lock_engaged()
	button_b.lock_engaged()

	door.open()

	exit_area.body_entered.connect(_on_body_enter_exit_area)
	exit_area.body_exited.connect(_on_body_exit_exit_area)

func reset_state():
	door.reset()

# Signals
func _on_button_a_engaged():
	button_a_engaged = true

func _on_button_a_disengaged():
	button_a_engaged = false

func _on_button_b_engaged():
	button_b_engaged = true

func _on_button_b_disengaged():
	button_b_engaged = false

func _on_body_enter_exit_area(body: Node3D):
	if body is not Player:
		return
	players_in_exit_area.append(body)

	# Get Alien / Human - this is hacky and will break
	# if the order of groups is changed.
	# We should introduce an enum for players or something
	if players_in_exit_area.size() == 2:
		exit.emit(players_in_exit_area[0].get_groups()[1])

func _on_body_exit_exit_area(body: Node3D):
	if body is not Player or players_in_exit_area.size() == 2:
		return
	players_in_exit_area = []
