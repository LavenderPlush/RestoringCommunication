extends AnimatableBody3D

@onready var activation_area: Area3D = $ActivationArea
@onready var timer: Timer = $Timer

@export_category("Designers")
##Time allowed between button presses.
@export var activation_timeframe: float = 5

#temp for mvp: spawn ladder at point
@onready var ladder_scene: PackedScene = preload("res://Entities/Ladder/ladder.tscn")
@export var ladder_spawn_point: Node3D

var press_count: int = 0
var original_position: Vector3
var press_offset: float = -0.05
var animation_duration: float = 0.2
var button_used: bool = false

func _ready() -> void:
	timer.wait_time = activation_timeframe
	timer.one_shot = true;
	original_position = self.position

	activation_area.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body):
	if button_used == true: return

	if not body.is_in_group("Player"): return

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
	if ladder_spawn_point == null: return

	button_used = true

	var ladder = ladder_scene.instantiate()

	get_parent().add_child(ladder)

	ladder.global_position = ladder_spawn_point.position
	ladder.global_rotation = ladder_spawn_point.rotation

func animate_button(target_y: float):
	var tween = create_tween()

	tween.tween_property(self, "position:y", target_y, animation_duration)
