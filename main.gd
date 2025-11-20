extends Node3D

@export var level_1: Node3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = !get_tree().paused
