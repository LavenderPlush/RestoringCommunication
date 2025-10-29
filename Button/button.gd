extends AnimatableBody3D

@onready var activation_area: Area3D = $ActivationArea
@onready var timer: Timer = $Timer

##Time allowed between button presses.
@export var activation_timeframe: float = 5

var press_count: int = 0
var original_position: Vector3
var press_1_offset: float = -0.1
var press_2_offset: float = -0.2
var animation_duration: float = 0.2

func _ready() -> void:
	timer.wait_time = activation_timeframe
	timer.one_shot = true;
	original_position = self.position

	activation_area.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body):
	if not body.is_in_group("Player"): return
	
	var target_y

	press_count += 1

	if press_count == 1:
		timer.start()

		target_y= original_position.y + press_1_offset
		
	elif press_count == 2:
		if not timer.is_stopped():
			timer.stop()

			press_count = 0
			target_y = original_position.y + press_2_offset

			activate_button()

	animate_button(target_y)
	
func _on_timer_timeout():
	press_count = 0

	animate_button(original_position.y)

func activate_button():
	print("Button activated.")
	pass

func animate_button(target_y: float):
	var tween = create_tween()

	tween.tween_property(self, "position:y", target_y, animation_duration)
