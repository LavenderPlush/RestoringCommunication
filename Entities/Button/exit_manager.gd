extends Node

@export var button_a: ExitButton
@export var button_b: ExitButton
@export var door: Node3D
@export var required_hold_time: float = 0.1

var button_a_player: Node = null
var button_b_player: Node = null
var door_opened: bool = false
var hold_timer: float = 0.0

func _ready() -> void:
    set_process(true)

func _process(delta: float) -> void:
    if door_opened: return

    var a_held = button_a.is_engaged
    var b_held = button_b.is_engaged
    var is_valid_state = false

    if a_held && b_held:
        var player_a = button_a.current_player_body
        var player_b = button_b.current_player_body

        if player_a != null and player_b != null and player_a != player_b:
            is_valid_state = true

    if is_valid_state:
        hold_timer += delta

        if hold_timer >= required_hold_time:
            door_opened = true

            button_a.lock_engaged()
            button_b.lock_engaged()

            print("open door")
            set_process(false)
    else:
        hold_timer = 0.0