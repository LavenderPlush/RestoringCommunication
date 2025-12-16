extends Node2D

@export_category("Designers")
@export var fade_time: float = 4.0

@export_category("Developers")
@export var first_scene: PackedScene

@onready var container: CenterContainer = $CenterContainer
@onready var colorRect: ColorRect = $CenterContainer/Background
@onready var fade: ColorRect = $CenterContainer/Fade


func _ready() -> void:
	container.custom_minimum_size = get_viewport_rect().size
	colorRect.custom_minimum_size = get_viewport_rect().size
	fade.custom_minimum_size = get_viewport_rect().size

	# Fade in
	var tween = get_tree().create_tween()
	await tween.tween_property(fade, "modulate", Color.TRANSPARENT, fade_time / 2).finished
	# Fade out
	tween = get_tree().create_tween()
	await tween.tween_property(fade, "modulate", Color.BLACK, fade_time / 2).finished
	
	# Start game
	get_tree().change_scene_to_packed(first_scene)
