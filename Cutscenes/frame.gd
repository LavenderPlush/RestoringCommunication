class_name Frame extends TextureRect

@export_group("Designers")
@export var time_before_start: float = 1.0
@export var fade_in_time: float = 0.2

var id: int

signal finish(id: int)

func _ready() -> void:
	modulate.a = 0

func play(_id: int) -> void:
	id = _id
	await get_tree().create_timer(time_before_start).timeout
	fade_in()

func fade_in() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, fade_in_time)
	tween.tween_callback(finish_playing)

func finish_playing() -> void:
	finish.emit(id)
