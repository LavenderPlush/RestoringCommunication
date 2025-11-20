class_name CutscenePlayer extends GameScene

@export_category("Developers")
@export var frames: Array[Frame]

var current_frame: int = 0

func _ready() -> void:
	if frames.size() == 0:
		finish_scene()
		return

	for frame in range(frames.size()):
		frames[frame].finish.connect(frame_finish)

	# Play first frame
	play_frame()

func play_frame() -> void:
	frames[current_frame].play(current_frame)

# Signals
func frame_finish(id) -> void:
	if id == current_frame:
		if current_frame == frames.size() - 1:
			finish_scene()
		else:
			current_frame += 1
			play_frame()
