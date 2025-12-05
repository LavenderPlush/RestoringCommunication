class_name Common

static func reparent_children(a: Node3D, b: Node3D):
	for child in a.get_children():
		if child != b:
			child.reparent(b, true)

static func play_sound(emitter: FmodEventEmitter3D):
	if emitter:
		emitter.play()

static func stop_sound(emitter: FmodEventEmitter3D):
	if emitter:
		emitter.stop()
