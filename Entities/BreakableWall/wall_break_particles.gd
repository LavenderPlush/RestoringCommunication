extends GPUParticles3D

func _ready() -> void:
	emitting = true

	await get_tree().process_frame
	
	emitting = false

	restart()

func _on_finished() -> void:
	queue_free()
