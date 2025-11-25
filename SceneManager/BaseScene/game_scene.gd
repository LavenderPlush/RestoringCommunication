class_name GameScene extends Node3D

signal finished(custom_skip: int)

func finish_scene() -> void:
	finished.emit(1)
