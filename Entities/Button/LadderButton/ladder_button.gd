extends ButtonBase

@onready var timer: Timer = $Timer
@onready var animator: AnimationPlayer = $Mesh/AnimationPlayer

@export_category("Designers")
##Time allowed between button presses.
@export var activation_timeframe: float = 5
##Drag extendable_ladder scene here.
@export var extendable_ladder: Area3D

@export_category("Sound")
@export var half_emitter: FmodEventEmitter3D
@export var full_emitter: FmodEventEmitter3D
@export var release_emitter: FmodEventEmitter3D

var press_count: int = 0
var press_offset: float = -0.05
var button_used: bool = false

func _ready() -> void:
	super._ready()

	timer.wait_time = activation_timeframe
	timer.one_shot = true

	player_entered.connect(_on_player_entered)
	timer.timeout.connect(_on_timer_timeout)

func _on_player_entered(_body: Node3D):
	if button_used == true: return

	if press_count == 1:
		Common.play_sound(full_emitter)
	else:
		Common.play_sound(half_emitter)

	if press_count >= 2: return
	
	press_count += 1
	timer.start()
		
	if press_count == 1:
		animator.play("half_press")
	elif press_count == 2:
		animator.play("full_press")

		activate_button()
	
func _on_timer_timeout():
	if button_used == true: return
	
	Common.play_sound(release_emitter)

	animator.play_backwards("half_press")
	press_count = 0

func activate_button():
	if extendable_ladder == null: return

	button_used = true
	extendable_ladder.call_deferred("extend_ladder")

func reset_state():
	super()
	
	press_count = 0
	button_used = false
	timer.stop()
	animator.play("RESET")
