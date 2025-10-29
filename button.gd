extends StaticBody3D

@onready var activation_area: Area3D = $ActivationArea
@onready var timer: Timer = $Timer
@onready var mesh: MeshInstance3D = $MeshInstance3D

##Time allowed between button presses.
@export var activation_timeframe: float = 5

var press_count: int = 0

func _ready() -> void:
	timer.wait_time = activation_timeframe
	timer.one_shot = true;

	activation_area.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body):
	if not body.is_in_group("Player"): return

	press_count += 1

	if press_count == 1:
		timer.start()
	elif press_count == 2:
		if not timer.is_stopped():
			timer.stop()
			press_count = 0
			
			activate_button()

func _on_timer_timeout():
	press_count = 0

func activate_button():
	print("Button activated.")

	pass
