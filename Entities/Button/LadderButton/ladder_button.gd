extends ButtonBase

@onready var animator: AnimationPlayer = $Mesh/AnimationPlayer

@export_category("Designers")
##Drag extendable_ladder scene here.
@export var extendable_ladder: Area3D

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
	if extendable_ladder == null: return

	button_used = true
	extendable_ladder.call_deferred("extend_ladder")

func reset_state():
	super()
	
	button_used = false
	animator.play("RESET")
