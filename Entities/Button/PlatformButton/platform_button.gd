extends ButtonBase

@onready var animator: AnimationPlayer = $Mesh/AnimationPlayer

@export_category("Designers")
##Drag moving_platform scene here.
@export var moving_platform: Node3D

@export_category("Sound")
@export var full_emitter: FmodEventEmitter3D

var button_used: bool = false

func _ready() -> void:
	super._ready()

	player_entered.connect(_on_player_entered)

func _on_player_entered(_body: Node3D):
	if button_used == true: return

	Common.play_sound(full_emitter)

	animator.play("full_press")

	activate_button()

func activate_button():
	if moving_platform == null: return

	button_used = true
	moving_platform.move()

func reset_state():
	super()
	
	button_used = false
	animator.play("RESET")
