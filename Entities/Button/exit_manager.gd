extends Node

@export var button_a: ExitButton
@export var button_b: ExitButton
@export var door: Node3D

var button_a_player: Node = null
var button_b_player: Node = null
var door_opened: bool = false

func _ready() -> void:
    button_a.engaged.connect(_on_button_a_engaged)
    button_b.engaged.connect(_on_button_b_engaged)
    button_a.disengaged.connect(_on_button_a_disengaged)
    button_a.disengaged.connect(_on_button_b_disengaged)

func check_activation():
    if door_opened: return

    if button_a_player != null && button_b_player != null:
        if button_a_player != button_b_player:
            # door_opened = true
            print("door opened")

func _on_button_a_engaged(player_body: Node3D):
    button_a_player = player_body
    
    check_activation()

func _on_button_a_disengaged():
    button_a_player = null

func _on_button_b_engaged(player_body: Node3D):
    button_b_player = player_body
    check_activation()

func _on_button_b_disengaged():
    button_b_player = null