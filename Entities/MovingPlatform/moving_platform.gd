extends AnimatableBody3D

@export_category("Movement Settings")
##This Object will keep resetting until Players reach this Checkpoint ID. Keep at -1 to always reset.
@export var reset_until_checkpoint_id: int = -1
@export var point_a: Marker3D
@export var point_b: Marker3D
@export var speed: float = 2.0
@export var wait_time: float = 1.0
@export var auto_start: bool = true

var tween: Tween
var original_position: Vector3

func _ready() -> void:
	add_to_group("resettable")

	original_position = position
	global_position = point_a.global_position
	
	if auto_start:
		_start_loop()

func move() -> void:
	if !tween:
		_start_loop()

		return

	if tween.is_running():
		tween.pause()
	else:
		tween.play()

func _start_loop() -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	
	tween.set_loops()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

	var start_pos = point_a.global_position
	var end_pos = point_b.global_position
	var distance = start_pos.distance_to(end_pos)
	var duration = 0.0

	if speed > 0.0:
		duration = distance / speed

	tween.tween_property(self, "global_position", end_pos, duration)
	tween.tween_interval(wait_time)

	tween.tween_property(self, "global_position", start_pos, duration)
	tween.tween_interval(wait_time)

func reset_state():
	if auto_start: return

	if tween:
		tween.stop()

	global_position = original_position
