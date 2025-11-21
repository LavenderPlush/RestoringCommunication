extends Node3D

##This decides how long the fade takes when transitioning scenes
@export var fade_time: float = 1.0
##The order decides the order of the scenes
@export var scenes: Array[PackedScene]

@export var overlay: ColorRect

var current_scene: int
var scene_loaded: GameScene

func _ready() -> void:
	if scenes.size() == 0:
		return
	load_scene(0)
	
func load_scene(id: int):
	await fade_in()
	unload_scene()
	current_scene = id
	var new_scene = scenes[id].instantiate()
	add_child(new_scene)
	scene_loaded = new_scene
	scene_loaded.finished.connect(scene_finished)
	fade_out()

func unload_scene():
	if not scene_loaded:
		return
	scene_loaded.queue_free()
	scene_loaded = null

func fade_in():
	var tween = get_tree().create_tween()
	await tween.tween_property(overlay, "modulate", Color.BLACK, fade_time).finished

func fade_out():
	var tween = get_tree().create_tween()
	await tween.tween_property(overlay, "modulate", Color.TRANSPARENT, fade_time).finished

# Signals
func scene_finished():
	if current_scene == scenes.size() - 1:
		return
	load_scene(current_scene + 1)
