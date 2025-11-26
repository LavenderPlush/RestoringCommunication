extends Node3D

##This decides how long the fade takes when transitioning scenes
@export var fade_time: float = 1.0
##The order decides the order of the scenes
@export var scenes: Array[PackedScene]

@export var overlay: ColorRect

var current_scene: int
var scene_loaded: GameScene

# Branching
var branching_offset: bool = false

func _ready() -> void:
	if scenes.size() == 0:
		return
	load_scene(0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("developer_next_scene"):
		var next_scene = current_scene + 1
		if next_scene < scenes.size():
			load_scene(next_scene)
	if event.is_action_pressed("developer_previous_scene"):
		var previous_scene = current_scene - 1
		if previous_scene >= 0:
			load_scene(previous_scene)
	
func load_scene(id: int):
	await fade_in()
	unload_scene()
	current_scene = id
	var new_scene = scenes[id].instantiate()
	add_child(new_scene)
	scene_loaded = new_scene
	scene_loaded.finished.connect(scene_finished)
	scene_loaded.finished_branch.connect(scene_finished_branching)
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

	if branching_offset:
		load_scene(current_scene + 2)
		branching_offset = false
	else:
		load_scene(current_scene + 1)

func scene_finished_branching(branch: int):
	if current_scene == scenes.size() - branch:
		return
	if branch == 1:
		branching_offset = true
	load_scene(current_scene + branch)
