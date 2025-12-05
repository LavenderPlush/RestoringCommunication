class_name CutscenePlayer extends GameScene

@export_category("Designers")
@export var wait_time: float = 3.0
@export var seconds_to_skip: float = 1.0

@export_category("Developers")
@export var frame_holder: Control
@export var wait_timer: Timer
@export var progress_bar: ProgressBar
@export var skip_label: Label

@export_category("Sound")
@export var bgm_emitter: FmodEventEmitter3D

var frames: Array[Frame] = []
var current_frame: int = 0

var hold_to_skip: bool = false

func _ready() -> void:
	load_frames()
	if frames.size() == 0:
		finish_scene()
		return
	
	progress_bar.max_value = seconds_to_skip * 100.0
	
	# Wait before playing
	wait_timer.timeout.connect(play_frame)
	wait_timer.start(wait_time)
	
	# Start music
	get_tree().create_timer(wait_time).timeout.connect(func (): bgm_emitter.play())

func _process(delta: float) -> void:
	if hold_to_skip:
		if progress_bar.value == progress_bar.max_value:
			skip_scene()
			hold_to_skip = false
		else:
			progress_bar.value += delta * 100

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("human_jump") or event.is_action_pressed("alien_jump"):
		hold_to_skip = true
		skip_frame()
		progress_bar.visible = true
		skip_label.visible = true
	if event.is_action_released("human_jump") or event.is_action_released("alien_jump"):
		hold_to_skip = false
		progress_bar.value = 0
		progress_bar.visible = false
		skip_label.visible = false

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
		bgm_emitter.set_parameter("Ambience", frames[current_frame].ambience)
		current_frame += 1

func skip_frame() -> void:
	if !wait_timer.is_stopped():
		wait_timer.stop()
	if current_frame < frames.size():
		frames[current_frame].stop()
	play_frame()

func skip_scene() -> void:
	frames[current_frame - 1].stop()
	if current_frame < frames.size():
		frames[current_frame].stop()
	finish_scene()

# Signals
func frame_finish(id) -> void:
	if id == current_frame - 1:
		play_frame()
