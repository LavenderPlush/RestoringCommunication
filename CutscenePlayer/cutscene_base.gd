class_name CutscenePlayer extends GameScene

@export_category("Designers")
@export var wait_time: float = 3.0

@export_category("Developers")
@export var frame_holder: Control

var frames: Array[Frame] = []
var current_frame: int = 0

func _ready() -> void:
	load_frames()
	
	if frames.size() == 0:
		finish_scene()
		return
	
	# Wait before playing
	await wait()

	# Play first frame
	play_frame()

func wait() -> void:
	await get_tree().create_timer(wait_time).timeout

func load_frames() -> void:
	var raw_frames = frame_holder.get_children()
	for frame in raw_frames:
		if frame is Frame:
			frames.append(frame)
	
	for frame in range(frames.size()):
		frames[frame].finish.connect(frame_finish)

func play_frame() -> void:
	frames[current_frame].play(current_frame)

func skip_frame() -> void:
	frames[current_frame].stop()
	current_frame += 1
	play_frame()

# Signals
func frame_finish(id) -> void:
	if id == current_frame:
		if current_frame == frames.size() - 1:
			finish_scene()
		else:
			current_frame += 1
			play_frame()
