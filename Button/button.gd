extends AnimatableBody3D

@onready var activation_area: Area3D = $ActivationArea
@onready var timer: Timer = $Timer

##Time allowed between button presses.
@export var activation_timeframe: float = 5

var press_count: int = 0
var original_position: Vector3
var press_offset: float = -0.1
var animation_duration: float = 0.2

func _ready() -> void:
	timer.wait_time = activation_timeframe
	timer.one_shot = true;
	original_position = self.position

	activation_area.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body):
	if not body.is_in_group("Player"): return

	if press_count >= 2: return
	
	press_count += 1

	var target_y = original_position.y + (press_count * press_offset)

	timer.start()
		
	if press_count == 2:
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
