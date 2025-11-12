extends Node

@export var button_a: ExitButton
@export var button_b: ExitButton
@export var door: Node3D

var required_hold_time: float = 0.1
var door_offset: float = 4.0
var animation_duration: float = 1.0
var hold_timer: float = 0.1
var button_a_engaged: bool = false
var button_b_engaged: bool = false
var door_opened: bool = false

func _ready() -> void:
    if !button_a || !button_b || !door: return

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