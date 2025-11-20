extends ButtonBase

@onready var timer: Timer = $Timer

@export_category("Designers")
##Time allowed between button presses.
@export var activation_timeframe: float = 5
##Drag moving_platform scene here.
@export var moving_platform: Node3D

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

	if press_count >= 2: return
	
	press_count += 1

	var target_y = original_position.y + (press_count * press_offset)

	timer.start()
		
	if press_count == 2:
		activate_button()

	animate_button(target_y)
	
func _on_timer_timeout():
	if button_used == true: return

	press_count = 0

	animate_button(original_position.y)

func activate_button():
	if moving_platform == null: return

	button_used = true
	moving_platform.move()

func reset_state():
	super()
	
	press_count = 0
	button_used = false
	timer.stop()
	
	animate_button(original_position.y)
