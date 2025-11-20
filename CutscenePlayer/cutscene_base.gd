class_name CutscenePlayer extends GameScene

@export_category("Designers")
@export var wait_time: float = 3.0

@export_category("Developers")
@export var frame_holder: Control
@export var wait_timer: Timer

var frames: Array[Frame] = []
var current_frame: int = 0

func _ready() -> void:
	load_frames()
	if frames.size() == 0:
		finish_scene()
		return
	
	# Wait before playing
	wait_timer.timeout.connect(play_frame)
	wait_timer.start(wait_time)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("alien_jump") or event.is_action_pressed("human_jump"):
			force_skip()

func load_frames() -> void:
	var raw_frames = frame_holder.get_children()
	for frame in raw_frames:
		if frame is Frame:
			frames.append(frame)
	
	for frame in range(frames.size()):
		frames[frame].finish.connect(frame_finish)

func play_frame() -> void:
	if current_frame > frames.size() - 1:
		finish_scene()
	else:
		frames[current_frame].play(current_frame)
		current_frame += 1

func force_skip() -> void:
	if wait_timer.time_left > 0:
		wait_timer.stop()
	frames[current_frame - 1].stop()
	play_frame()

# Signals
func frame_finish(id) -> void:
	if id == current_frame - 1:
		play_frame()
