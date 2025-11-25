class_name Frame extends TextureRect

@export_category("Designers")
@export var time_shown: float = 2.0
@export var fade_in_time: float = 0.2

@export_group("Sound")
@export var emitter: FmodEventEmitter3D
@export var ambience: String = "Chill":
	get(): return ambience

var id: int

signal finish(id: int)

func _ready() -> void:
	modulate.a = 0

func play(_id: int) -> void:
	id = _id
	Common.play_sound(emitter)
	fade_in()
	await get_tree().create_timer(time_shown).timeout
	finish_playing()

func stop() -> void:
	Common.stop_sound(emitter)

func fade_in() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, fade_in_time)

func finish_playing() -> void:
	finish.emit(id)
